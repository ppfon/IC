#ifndef DC_CONVERTER_H
#define DC_CONVERTER_H

#include <math.h>

// Input Definitions
#define Ibat Input(0)
#define Ibat2 Input(1)
#define Ibat3 Input(2)
#define Ibat4 Input(3)
#define Ibat5 Input(4)
#define Ibat6 Input(5)
#define control_enable Input(6)
#define Iref_ch Input(7)
#define Iref_dis Input(8)
#define Vbat Input(9)
#define Vdc Input(10)
#define Soc Input(11)
#define reset Input(12)

// Parameter Definitions
#define fsw ParamRealData(0,0)    
#define Ts ParamRealData(1,0)   
#define fdsp ParamRealData(2,0)  
#define Kpbt ParamRealData(3,0)   
#define Kibt ParamRealData(4,0)   
#define Kpvbu ParamRealData(5,0)   
#define Kivbu ParamRealData(6,0)  
#define Kpibu ParamRealData(7,0)   
#define Kiibu ParamRealData(8,0)  
#define Soc_min ParamRealData(9,0)   
#define Soc_max ParamRealData(10,0)   
#define Nb_series ParamRealData(11,0)   
#define Nb_strings ParamRealData(12,0)  

#define N_br  6                     // Number of interleaved phases
#define PRD  ((fdsp/fsw)/2)         // Counter period for up/down counting
#define PRD_div2  (PRD/2)           // Half period
#define pi    3.141592653589793   
#define wn    (2*pi*50.0)           // Fundamental angular frequency (50 Hz assumed)
#define N     150                   // Number of points in fundamental

// Battery Parameters
float Vboost = 14.4;               // Boost voltage
float Vfloat = 13.6;               // Float voltage

// References
float Vref = 0;
float Ibat_total = 0;              // Sum of all phase currents

// PI Controller Structure
typedef struct {
    float Xref;
    float Xm;
    float erro;
    float erro_ant;
    float inte;
    float inte_ant;
    float duty;
    float piout;
    float piout_sat;
    float erropi;
    float erropi_ant;
    float dif;
    float Kp;
    float Ki;
} sPI;

#define PI_default {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

// Arrays for PI Controllers (6 phases)
sPI PIbt[6] = {PI_default};        // Boost mode PI controllers
sPI PIbu[6] = {PI_default};        // Buck mode PI controllers
sPI PIbuv = PI_default;            // Voltage PI controller (shared)

float sat_up = 1;
float sat_down = -1;

// Ramp Structure
typedef struct {
    float t1;
    float t1_ant;
    float y;
    float y_ant;
    float uin;
    float rate;
    float rising; 
    float falling;
} sRamp;

#define IRamp_default {0,0,0,0,0,0,(15),(-15)} 
#define VRamp_default {0,0,0,0,0,0,(500),(-500)} 
sRamp IRamp_bt[6] = {IRamp_default};  // Ramp for each phase
sRamp VRamp = VRamp_default;

// Flags
typedef struct {
    int CM;      // Charge mode
    int BVCM;    // Boost Charge mode
    int DM;      // Discharge mode
} sflag;

#define IFlag_default {0,0,1} 
sflag flag = IFlag_default;

// PWM Parameters
static int count[6];               // Counter array for 6 phases
static int inc[6];                 // Increment direction array
static int CMPB = 0;
static int S[12];                  // Switch states (2 switches per phase)
static int teste = 0;

// Function Declarations
void Ramp(sRamp *rmp, float sample);
void Pifunc(sPI *reg, float T_div2, float Kp, float Ki, float satup, float satdown);
void updateCounters(int count[], int inc[], int PRD);
void initializePhases(int count[], int inc[], int PRD);

#endif // DC_CONVERTER_H