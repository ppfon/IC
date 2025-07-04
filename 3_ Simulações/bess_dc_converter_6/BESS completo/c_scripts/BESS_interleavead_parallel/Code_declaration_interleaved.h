/**
 * @file Code_declaration_interleaved.h
 * @brief Declarations for a 6-phase interleaved DC/DC converter controller.
 * @details This header file defines the data structures, constants, inputs, parameters,
 * and function definitions for the PLECS C-Script controller.
 * @author Gemini AI (based on user's code)
 * @version 1.4
 * @date 2025-06-28
 */

#include <math.h>

// --- INPUTS, PARAMETERS, CONSTANTS, and STRUCTS (Unchanged) ---

#define control_enable  Input(6)
#define Iref_ch         Input(7)
#define Iref_dis        Input(8)
#define Vbat            Input(9)
#define Vdc             Input(10)
#define Soc             Input(11)
#define reset           Input(12)
#define fsw             ParamRealData(0,0)
#define Ts              ParamRealData(1,0)
#define fdsp            ParamRealData(2,0)
#define Kpbt            ParamRealData(3,0)
#define Kibt            ParamRealData(4,0)
#define Kpvbu           ParamRealData(5,0)
#define Kivbu           ParamRealData(6,0)
#define Kpibu           ParamRealData(7,0)
#define Kiibu           ParamRealData(8,0)
#define Soc_min         ParamRealData(9,0)
#define Soc_max         ParamRealData(10,0)
#define NB_SERIES       ParamRealData(11,0)
#define NB_STRINGS      ParamRealData(12,0)
#define N               6
#define PRD             (fdsp/fsw)/2
#define VBOOST          14.4
#define VFLOAT          13.6

#define SAT_UP          1.0
#define SAT_DOWN        -SAT_UP
#define IREF_SAT_LOW    -10.0
#define IREF_DIS_MAX    16.0
#define VDC_MAX         550.0

typedef enum { MODE_DISCHARGE, MODE_CHARGE } OperationMode;

typedef struct {
    OperationMode mode;
    int boost_charge_active;
} ConverterState;

#define STATE_DEFAULT {MODE_DISCHARGE, 0}
ConverterState state = STATE_DEFAULT;

typedef struct {
    float Xref, Xm, erro, erro_ant, inte, inte_ant, duty, piout, piout_ant;
    float piout_sat, erropi, erropi_ant, dif, Kp, Ki;
} sPI;

#define PI_DEFAULT {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

typedef struct {
    float t1, t1_ant, y, y_ant, uin, rate, rising, falling;
} sRamp;

#define IRAMP_DEFAULT {0,0,0,0,0,0, IREF_DIS_MAX, -IREF_DIS_MAX} 
#define VRAMP_DEFAULT {0,0,0,0,0,0, VDC_MAX, -VDC_MAX}

sPI PIbt[N];
sPI PIbu[N];
sRamp IRamp[N];

sPI PIbuv = PI_DEFAULT;
sRamp VRamp = VRAMP_DEFAULT;
const sPI PI_DEFAULT_INSTANCE = PI_DEFAULT;
const sRamp IRAMP_DEFAULT_INSTANCE = IRAMP_DEFAULT;

float count[N] = {0, 10, 20, 30, 40, 50};
float inc[N] = {0.5, 0.5, 0.5, 0.5, 0.5, 0.5};
int S[2 * N];

static int is_initialized = 0; 

// --- FUNCTION DEFINITIONS ---

/**
 * @brief Implements a ramp function to smoothly change a value towards a target.
 * @param[in,out] rmp Pointer to the ramp controller structure to be updated.
 * @param[in] sample The sample time (Ts) of the controller.
 */
static inline void Ramp(sRamp *rmp, float sample) {
    if (rmp->uin != rmp->y) 
      rmp->t1 = rmp->t1 + sample; 
    else rmp->t1 = 0;

    rmp->rate = (rmp->uin - rmp->y_ant) / (rmp->t1 - rmp->t1_ant);

    if (rmp->rate > rmp->rising) 
      rmp->y = (rmp->t1 - rmp->t1_ant) * rmp->rising + rmp->y_ant;
    else 
      if (rmp->rate < rmp->falling) 
        rmp->y = (rmp->t1 - rmp->t1_ant) * rmp->falling + rmp->y_ant;
      else rmp->y = rmp->uin;

    rmp->t1_ant = rmp->t1;
    rmp->y_ant = rmp->y;	
}

/**
 * @brief Implements a Proportional-Integral (PI) controller with anti-windup.
 * @param[in,out] reg Pointer to the PI controller structure to be updated.
 * @param[in] T_div2 Half of the sampling period, used in the integration step.
 * @param[in] Kp The proportional gain for the controller.
 * @param[in] Ki The integral gain for the controller.
 * @param[in] satup The upper saturation limit for the PI output.
 * @param[in] satdown The lower saturation limit for the PI output.
 */
static inline void Pifunc(sPI *reg, float T_div2, float Kp, float Ki, float satup, float satdown) {
    reg->erro = reg->Xref - reg->Xm;
    reg->erropi = reg->erro - (1.0f / Kp) * reg->dif;

    reg->inte = reg->inte_ant + T_div2 * (reg->erropi + reg->erropi_ant); 
    reg->inte_ant = reg->inte;

    reg->erropi_ant = reg->erropi;
    reg->piout = (Kp * reg->erro + Ki * reg->inte); 
    reg->piout_sat = reg->piout;

    if (reg->piout > satup) 
      reg->piout_sat = satup;
    if (reg->piout < satdown) 
      reg->piout_sat = satdown;

    reg->dif = reg->piout - reg->piout_sat;
}