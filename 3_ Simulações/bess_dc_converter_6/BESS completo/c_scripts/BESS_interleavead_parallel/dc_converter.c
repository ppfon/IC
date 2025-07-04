#include "dc_converter.h"

// Number of interleaved phases (e.g., 6 for a 6-branch converter)
#define N_br 6

// Global flag to ensure one-time initialization
static int initialized = 0;

//------------------------------------------------------------------------------
// Function: updateCounters
// Purpose:  Advance or retract each triangular counter between 0 and PRD
// Inputs:
//   count[] - array of current counter values for each phase
//   inc[]   - array of +1 or -1, indicating counting direction
//   PRD     - the half-period of the triangular carrier (peak count)
// Behavior:
//   Each counter moves by its inc[]. When reaching PRD or 0, the direction
//   reverses and the counter is clamped at the boundary.
// Equation:
//   count[i]_{new} = clamp( count[i] + inc[i], 0, PRD )
//   if count hits boundary, inc[i] *= -1
//------------------------------------------------------------------------------
void updateCounters(int count[], int inc[], int PRD) {
    for (int i = 0; i < N_br; i++) {
        count[i] += inc[i];
        if (count[i] >= PRD) {
            count[i] = PRD;
            inc[i] = -1;    // reverse: start counting down
        }
        if (count[i] <= 0) {
            count[i] = 0;
            inc[i] = 1;     // reverse: start counting up
        }
    }
}

//------------------------------------------------------------------------------
// Function: initializePhases
// Purpose:  Compute the starting counter values for each branch to achieve
//           equal phase-shifts of 360/N_br degrees in the triangular carriers.
// Inputs:
//   count[] - output array of initial counter positions
//   inc[]   - output array of initial directions (+1 ascending, -1 descending)
//   PRD     - half-period count (peak of the triangular wave)
// Equations:
//   Total counts per full triangular cycle: T_counts = 2 * PRD
//   Phase shift per branch:        φ = 360° / N_br
//   Step offset (counts):          Δ = (φ / 360°) * T_counts
//   Raw start position:            raw = (PRD + 1) - i * Δ
//   Folding into [0, PRD]:
//     if raw <= PRD: count = raw, inc = +1 (ascending)
//     else:             count = 2*PRD - raw, inc = -1 (descending)
//------------------------------------------------------------------------------
void initializePhases(int count[], int inc[], int PRD) {
    int T_counts = 2 * PRD;                     // full triangular cycle length
    float phase_deg;
    for (int i = 0; i < N_br; i++) {
        // Phase angle for branch i
        phase_deg = i * (360.0f / N_br);
        // Convert degrees to count offset
        int phase_steps = (int)((phase_deg / 360.0f) * T_counts);

        // Compute raw start point: one count past the peak to trigger immediate down-count
        int raw = (PRD + 1) - phase_steps;

        // If raw lies on the ascending side
        if (raw >= 0 && raw <= PRD) {
            count[i] = raw;
            inc[i]   = +1;
        }
        // If raw lies past the peak, fold onto descending side
        else {
            // reflect around PRD: count = 2*PRD - raw
            count[i] = 2 * PRD - raw;
            inc[i]   = -1;
        }
    }
}

//------------------------------------------------------------------------------
// Function: plecsOutput
// Purpose:  Main PLECS C-Script function to produce PWM switch signals
//           for both discharge (DM) and charge (CM) modes.
// Inputs:
//   in[]   - input signals from PLECS (voltages, currents, flags, etc.)
//   out[]  - output switch commands S1..S12
// Globals:
//   count[], inc[], PRD, flags, ramps, PI controllers, etc.
//------------------------------------------------------------------------------
void plecsOutput(double *in, double *out) {
    // One-time initialization of phase counters
    if (!initialized) {
        initializePhases(count, inc, PRD);
        initialized = 1;
    }

    // Sum total battery current across all branches
    Ibat_total = Ibat + Ibat2 + Ibat3 + Ibat4 + Ibat5 + Ibat6;

    // Advance or retract each triangular counter
    updateCounters(count, inc, PRD);

    // CMPB is the PWM comparison baseline (often zero)
    CMPB = 0;

    if (control_enable == 1) {
        // Loop through each branch for control logic
        for (int i = 0; i < N_br; i++) {
            // When counter equals baseline, refresh references
            if (count[i] == CMPB) {
                if (reset == 1) {
                    // Discharge mode init: use distributed Iref_dis
                    flag.DM = 1;
                    flag.CM = 0;
                    for (int j = 0; j < N_br; j++)
                        IRamp_bt[j].uin = Iref_dis / N_br;
                    flag.BVCM = 0;
                } else {
                    // Continuous update: average battery current
                    float avg_Ibat = Ibat_total / N_br;
                    for (int j = 0; j < N_br; j++)
                        IRamp_bt[j].uin = avg_Ibat;
                }

                // Charge mode init when reset==2
                if (reset == 2) {
                    flag.DM = 0;
                    flag.CM = 1;
                    if (!flag.BVCM) {
                        Vref = Vboost * Nb_series;
                        VRamp.uin = Vref;
                        if (Vbat >= Vboost * Nb_series)
                            flag.BVCM = 1;
                    }
                    if (flag.BVCM && Ibat_total >= -0.1f * Iref_ch) {
                        Vref = Vfloat * Nb_series;
                        VRamp.uin = Vref;
                    }
                } else {
                    // Hold ramp input at battery voltage
                    VRamp.uin = Vbat;
                }

                // Run current and voltage Ramps
                Ramp(&IRamp_bt[i], Ts);
                if (i == 0)
                    Ramp(&VRamp, Ts);  // update voltage ramp once

                // Compute PI outputs & duty in Discharge Mode
                if (flag.DM == 1) {
                    PIbt[i].Xref = IRamp_bt[i].y;
                    PIbt[i].Xm   = (i == 0)? Ibat : (i == 1)? Ibat2 :
                                   (i == 2)? Ibat3 : (i == 3)? Ibat4 :
                                   (i == 4)? Ibat5 : Ibat6;
                    Pifunc(&PIbt[i], Ts/2, Kpbt, Kibt, sat_up, sat_down);
                    PIbt[i].duty = PIbt[i].piout_sat * PRD;
                }

                // Compute PI outputs & duty in Charge Mode
                if (flag.CM == 1) {
                    if (i == 0) {
                        PIbuv.Xref = VRamp.y;
                        PIbuv.Xm   = Vbat;
                        Pifunc(&PIbuv, Ts/2, Kpvbu, Kivbu,
                                Iref_ch/4, -10);
                    }
                    PIbu[i].Xref = PIbuv.piout_sat;
                    PIbu[i].Xm   = -( (i==0)? Ibat : (i==1)? Ibat2 :
                                      (i==2)? Ibat3 : (i==3)? Ibat4 :
                                      (i==4)? Ibat5 : Ibat6 );
                    Pifunc(&PIbu[i], Ts/2, Kpibu, Kiibu,
                            sat_up, sat_down);
                    PIbu[i].duty = PIbu[i].piout_sat * PRD;
                }
            }
        }

        // PWM switch assignment: Compare duty vs triangular count
        // Discharge Mode: even switches on when duty>=count
        if (flag.DM == 1 && flag.CM == 0) {
            for (int i = 0; i < N_br; i++) {
                if (PIbt[i].duty >= count[i]) {
                    S[2*i]   = 1;  // S2, S4,...  even
                    S[2*i+1] = 0;  // S1, S3,...  odd
                } else {
                    S[2*i]   = 0;
                    S[2*i+1] = 0;
                }
            }
        }
        // Charge Mode: odd switches on when duty>=count
        if (flag.CM == 1 && flag.DM == 0) {
            for (int i = 0; i < N_br; i++) {
                if (PIbu[i].duty >= count[i]) {
                    S[2*i+1] = 1;  // S1, S3,... odd
                    S[2*i]   = 0;  // S2, S4,... even
                } else {
                    S[2*i+1] = 0;
                    S[2*i]   = 0;
                }
            }
        }
    }

    // Map internal S[] array to PLECS outputs
    for (int k = 0; k < 12; k++) {
        Output(k) = S[k];
    }
}
