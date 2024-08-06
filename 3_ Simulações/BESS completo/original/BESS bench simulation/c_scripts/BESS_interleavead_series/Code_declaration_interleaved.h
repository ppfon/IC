#include <math.h>

#define Ibat Input (0)
#define Ibat2 Input (1)
#define Ibat3 Input (2)
#define pulse_on Input (3)
#define Vref_ch Input (4)
#define Vref_dis Input (5)
#define Vbat Input (6)
#define Vdc Input (7)
#define Soc Input (8)
#define Pref Input (9)

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
#define Kp_vout ParamRealData(13,0)
#define Ki_vout ParamRealData(14,0) 

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
    int enab;
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

#define PI_default {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

sPI PIbt = PI_default;
sPI PIbt2 = PI_default;
sPI PIbt3 = PI_default;
sPI PIbu = PI_default;
sPI PIbu2 = PI_default;
sPI PIbu3 = PI_default;
sPI PIbuv = PI_default;
sPI PIbt_vout = PI_default;
sPI PIbu_vout = PI_default;

float sat_up = 1;
float sat_down = -1;

typedef struct{
	float t1;
	float t1_ant;
	float y;
	float y_ant;
	float uin;
	float rate;
	float rising; 
	float falling;
} sRamp;
#define IRamp_default{0,0,0,0,0,0,(15),(-15)} 
#define VRamp_default{0,0,0,0,0,0,(250),(-250)} 
sRamp IRamp_bt  = IRamp_default;
sRamp IRamp2_bt = IRamp_default;
sRamp IRamp3_bt = IRamp_default;
sRamp VRamp     = VRamp_default;
sRamp VoutRamp  = VRamp_default;

//First order LPF
typedef struct {
  float Un;
  float Un_1;
  float Yn_1;
  float Yn;
  float c0;
  float c1;
} sFilter1st;
#define FILTER_DEFAULTS_1_HZ {0,0,0,0,0.00069813170079773186,0.00069813170079773186}
sFilter1st Filt_freq_Vdc = FILTER_DEFAULTS_1_HZ;

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
void Ramp(sRamp *rmp, float sample)
{
  if(rmp->uin != rmp->y) rmp->t1 = rmp->t1 + sample;

  if(rmp->t1 != rmp->t1_ant)
  {
    rmp->rate = (rmp->uin - rmp->y_ant)/(rmp->t1 - rmp->t1_ant);
  }
  else rmp->rate = 0;

  if(rmp->rate > rmp->rising) rmp->y = (rmp->t1 - rmp->t1_ant)*rmp->rising + rmp->y_ant;
  else if(rmp->rate < rmp->falling) rmp->y = (rmp->t1 - rmp->t1_ant)*rmp->falling + rmp->y_ant;
  else rmp->y = rmp->uin;

  rmp->t1_ant = rmp->t1;
  rmp->y_ant = rmp->y;	
}

// Controlador PI
void Pifunc(sPI *reg, float T_div2, float Kp, float Ki, float satup, float satdown)
{
  if (reg->enab == 1)
  {
    reg->erro = reg->Xref  - reg->Xm;

    reg->erropi = reg->erro - (1/Kp)*reg->dif;

    reg->inte = reg->inte_ant + T_div2 * (reg->erropi  + reg->erropi_ant);
    reg->inte_ant = reg->inte;
    reg->erropi_ant = reg->erropi;
  }
  else
  {
    reg->erro = 0;
    reg->inte = 0;
  }

  reg->piout = (Kp*reg->erro + Ki*reg->inte); 

  reg->piout_sat = reg->piout;
  if(reg->piout>satup) reg->piout_sat = satup;
  if(reg->piout<satdown) reg->piout_sat= satdown;

  reg->dif = reg->piout - reg->piout_sat;
}

// Low pass filter
void First_order_signals_filter(sFilter1st *x)
{
  x->Yn= (x->c0* x->Un) + (1-x->c1)*(x->Yn_1);
  x->Un_1= x->Un;
  x->Yn_1= x->Yn;
}