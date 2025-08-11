/**
 * @file Code_Output_interleaved.c
 * @brief Output function logic for the 6-phase interleaved DC/DC converter controller.
 * @details This file contains the runtime logic executed at each simulation step by PLECS.
 * @date 2025-06-28
 */

//--- SECTION: INITIALIZATION ---//
if (!is_initialized) {
    int i;
    for (i = 0; i < N; i++) {
        PIbt[i] = PI_DEFAULT_INSTANCE;
        PIbu[i] = PI_DEFAULT_INSTANCE;
        IRamp[i] = IRAMP_DEFAULT_INSTANCE;

        S[2 * i] = 0;
        S[2 * i + 1] = 0;
    }
    is_initialized = 1;
}

//--- SECTION: CARRIER GENERATION ---//
int i;
for (i = 0; i < N; i++) {
    count[i] += inc[i];

    if (count[i] >= PRD) 
      inc[i] = -1;
    if (count[i] <= 0) 
      inc[i] = 1;
}

//--- SECTION: CONTROL ENABLE CHECK ---//
if (control_enable == 0) {
    for(i=0; i<2*N; i++) { 
      Output(i) = 0; 
    }
    return;
}

//--- SECTION: STATE MACHINE & REFERENCE MANAGEMENT ---//
float total_Ibat = 0;
for(i = 0; i < N; i++) {
    total_Ibat += Input(i);
}

if (reset == 1) {
    state.mode = MODE_DISCHARGE;
    state.boost_charge_active = 0;
    for (i = 0; i < N; i++) {
        IRamp[i].uin = Iref_dis / N;
    }
} else if (reset == 2) {
    state.mode = MODE_CHARGE;
    if (state.boost_charge_active == 0) {
        VRamp.uin = VBOOST * NB_SERIES;
        if (Vbat >= VBOOST * NB_SERIES) {
            state.boost_charge_active = 1;
        }
    }
    if (state.boost_charge_active == 1 && total_Ibat >= -0.1 * Iref_ch) {
        VRamp.uin = VFLOAT * NB_SERIES;
    }
} else {
    if (state.mode == MODE_DISCHARGE) {
        float avg_I = total_Ibat / N;
        for (i = 0; i < N; i++) {
            IRamp[i].uin = avg_I;
        }
    }
}
Ramp(&VRamp, Ts);

//--- SECTION: CONTROL LOOPS ---//
for (i = 0; i < N; i++) {
    if (count[i] == 0 || count[i] == PRD) {
        Ramp(&IRamp[i], Ts);

        if (state.mode == MODE_DISCHARGE) {
            /*
            float duty_cycle_ff = 0;
            if (Vdc > 0) { // Avoid division by zero
                duty_cycle_ff = 1.0f - (Vbat / Vdc);
            }
            */
            // PIbt[i].Xref = IRamp[i].y;
            PIbt[i].Xref = IRamp[i].uin;
            PIbt[i].Xm = Input(i);
            Pifunc(&PIbt[i], Ts / 2, Kpbt, Kibt, SAT_UP, SAT_DOWN);
            PIbt[i].duty = PIbt[i].piout_sat* PRD;
        } 
        else if (state.mode == MODE_CHARGE) {
            if (i == 0) {
                PIbuv.Xref = VRamp.y;
                PIbuv.Xm = Vbat;
                Pifunc(&PIbuv, Ts / 2, Kpvbu, Kivbu, SAT_UP, SAT_DOWN);
                PIbu[0].Xref = PIbuv.piout_sat;
            } else {
                PIbu[i].Xref = PIbu[0].Xref;
            }
            
            PIbu[i].Xm = -Input(i);
            Pifunc(&PIbu[i], Ts / 2, Kpibu, Kiibu, SAT_UP, SAT_DOWN);
            PIbu[i].duty = PIbu[i].piout_sat * PRD;
        }
    }
}

//--- SECTION: PWM GENERATION ---//
for (i = 0; i < N; i++) {
    int s_high_idx = 2 * i;
    int s_low_idx = 2 * i + 1;
    S[s_high_idx] = 0;
    S[s_low_idx] = 0;

    if (state.mode == MODE_CHARGE) {
        if (PIbu[i].duty >= count[i]) {
            S[s_high_idx] = 1;
        }
    } else if (state.mode == MODE_DISCHARGE) {
        if (PIbt[i].duty >= count[i]) {
            S[s_low_idx] = 1;
        }
    }
}

//--- SECTION: ASSIGN TO OUTPUTS ---//
for (i = 0; i < 2 * N; i++) {
    Output(i) = S[i];
}

Output(12) = PIbt[0].piout_sat; // PIbt[0].erro;
Output(13) = PIbt[1].piout_sat; //PIbt[1].erro;
Output(14) = PIbt[2].piout_sat; //PIbt[2].erro;
Output(15) = PIbt[3].piout_sat; //PIbt[3].erro;
Output(16) = PIbt[4].piout_sat; //PIbt[4].erro;
Output(17) = PIbt[5].piout_sat; //PIbt[5].erro;