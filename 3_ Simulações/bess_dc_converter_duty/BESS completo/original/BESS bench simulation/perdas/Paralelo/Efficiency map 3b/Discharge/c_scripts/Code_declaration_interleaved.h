#include <math.h>

#define Ibat Input (0)
#define Ibat2 Input (1)
#define Ibat3 Input (2)
#define control_enable Input (3)
#define Iref_ch Input (4)
#define Pref Input (5)
#define Vbat Input (6)
#define Vdc Input (7)
#define Soc Input (8)
#define reset Input (9)

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
#define Kpp ParamRealData(13,0)   
#define Kip ParamRealData(14,0)  

#define N_br  3                                        //Número de braços do interleaved
#define PRD  (fdsp/fsw)/2                                    // COntador Up e Down, PRD = (fdsp/fsw)/2 
#define PRD_div2  PRD/2                                      // PRD_div2 = PRD/2;
#define pi    3.141592653589793   
#define wn    2*pi*fn                                       //Frequência angular fundamental
#define N     150                                       // Numero de pontos da fundamental N = fs/fn;     
  
// Parâmetros da bateria
float Vboost = 14.4;               //Tensão de boost
float Vfloat = 13.6;               //Tensão de float

//Referências
float Vref = 0;

//...............Parametros do Controle do DC/dc
typedef struct {
    float Xref;
    float Xm;
    float erro;
    float erro_ant;
    float inte;
    float inte_ant;
    float duty;
    float piout;
    float piout_ant;
    float piout_sat;
    float erropi;
    float erropi_ant;
    float dif;
    float Kp;
    float Ki;
} sPI;

#define PI_default {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

sPI PIbt = PI_default;
sPI PIbt2 = PI_default;
sPI PIbt3 = PI_default;
sPI PIbu = PI_default;
sPI PIbu2 = PI_default;
sPI PIbu3 = PI_default;
sPI PIbuv = PI_default;
sPI PIp = PI_default;

float sat_up = 1;
float sat_down = -1;

typedef struct{
float final;
float final_ant;
float atual;
float in;
float delta;
int flag;
int flag2;
float range;
float inc;
} sRamp;

#define PRamp_default {0,0,0,0,0,0,0,0.1,500}    
#define VRamp_default {0,0,0,0,0,0,0,0.1,0.05} 
sRamp VRamp     = VRamp_default;
sRamp PRamp     = PRamp_default;


typedef struct{
int CM;      //Charge mode
int BVCM;    // Boost Charge mode
int DM;      // Discharge mode
} sflag;

#define IFlag_default {0,0,1} 
sflag flag = IFlag_default;

//................Parametros do PWM
int count_0 = 61;
int count_120 = 19;
int count_240 = 21;
int inc = -1;
int inc_120 = 1;
int inc_240 = -1;
int CMPB = 0;
int S1 = 0;
int S2 = 0;
int S3 = 0;
int S4 = 0;
int S5 = 0;
int S6 = 0;
int teste = 0;

///////////////////////////////////////Funções/////////////////////

// Rampa
void Ramp(sRamp *rmp)
{
    if(rmp->final != rmp->final_ant)
    {
        rmp->flag = 0;
        rmp->flag2 = 1;
    }

    rmp->final_ant = rmp->final;

    if(rmp->flag == 0)
    {
        rmp->atual = rmp->in;
        rmp->flag = 1;
    }

    rmp->delta = rmp->final - rmp->atual;

    if(rmp->flag2 == 1)
    {
        if(rmp->delta > 0)
        {
            rmp->atual += rmp->inc;
            if(rmp->delta<=rmp->range)
            {
                rmp->atual = rmp->final;
                rmp->flag2 = 0;
            }
        }
        else if(rmp->delta < 0)
        {
            rmp->atual -= rmp->inc;
            if(rmp->delta>=rmp->range)
            {
                rmp->atual = rmp->final;
                rmp->flag2 = 0;
            }

        }
    }
}

// Controlador PI
void Pifunc(sPI *reg, float T_div2, float Kp, float Ki, float satup, float satdown)
{
    reg->erro = reg->Xref  - reg->Xm;

    reg->erropi = reg->erro - (1/Kp)*reg->dif;

    reg->inte = reg->inte_ant + T_div2 * (reg->erropi  + reg->erropi_ant);
    reg->inte_ant = reg->inte;
    reg->erropi_ant = reg->erropi;

    reg->piout = (Kp*reg->erro + Ki*reg->inte); 

    reg->piout_sat = reg->piout;
    if(reg->piout>satup) reg->piout_sat = satup;
    if(reg->piout<satdown) reg->piout_sat= satdown;

    reg->dif = reg->piout - reg->piout_sat;
}