#include <math.h>

#define Vdc Input (0)
#define Vabcp_a Input (1)
#define Vabcp_b Input (2)
#define Vabcp_c Input (3)
#define Vabcn_a Input (4)
#define Vabcn_b Input (5)
#define Vabcn_c Input (6)
#define teta1 Input (7)
#define teta2 Input (8)
#define v_alpha Input (9)
#define v_beta Input (10)
#define Pcc_a Input (11)
#define Pcc_b Input (12)
#define Pcc_c Input (13)
#define Isa Input (14)
#define Isb Input (15)
#define Isc Input (16)
#define control_enable Input (17)
#define Vdc_ref Input (18)
#define Qref Input (19)





#define fsw     ParamRealData(0,0)    
#define Ts      ParamRealData(1,0)   
#define fdsp    ParamRealData(2,0)  
#define Kpouter ParamRealData(3,0)  
#define Kiouter ParamRealData(4,0)  
#define Kp_pll  ParamRealData(5,0)
#define Ki_pll  ParamRealData(6,0)
#define Kp_res  ParamRealData(7,0)
#define Ki_res  ParamRealData(8,0)
#define Kiq     ParamRealData(9,0)

#define PRD  (fdsp/fsw)/2           						 // COntador Up e Down, PRD = (fdsp/fsw)/2 
#define PRD_div2  PRD/2              						 // PRD_div2 = PRD/2;
#define pi    3.141592653589793   
#define wn    2*pi*fn                 						 //Frequência angular fundamental 
#define N     150               						   

// controle IARC - variáveis de calculos intermediários


float VabcP;
float VabcN;
float Vsoma;
float Vcorr;
float Pref;
//float Qref;
float divide;
float divide_1;
float prod_1x;
float prod_1y;
float prod_1z;
float Pcc_a_trans; 
float Pcc_b_trans; 
float Pcc_c_trans; 
float Vabcp_a_trans; 
float Vabcp_b_trans; 
float Vabcp_c_trans;
float Vabcn_a_trans; 
float Vabcn_b_trans; 
float Vabcn_c_trans;
float prod_2x;
float prod_2y;
float prod_2z;
float soma_prod_x;
float soma_prod_y;
float soma_prod_z;
float I_a; 
float I_b;






//...............Variáveis do Controle da tensão do link cc
float psat = 10e3;

//...............Variáveis do Controle de corrente do inversor
float Ir = 30;
float Pc = 0;
float Qc = 0;
float Q_control = 0;
float P_control = 0;
float Vpwm_norm_a = 0;
float Vpwm_norm_b = 0;
float Vpwm_norm_c = 0;
float vmin = 0;
float vmax = 0; 
float vsa_svpwm = 0;
float vsb_svpwm = 0;
float vsc_svpwm = 0;
float dutya = 0;
float dutyb = 0;
float dutyc = 0;
int counti = 0;
int count_pll = 0;
//

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
	float erropi_ant ;
	float dif;
} sPI;

#define PI_default {0,0,0,0,0,0,0,0,0,0,0,0,0}

sPI PIvdc = PI_default;
sPI PIpll = PI_default;
sPI PIq   = PI_default;

typedef struct {
float Xref;
float Xm;
float erro;
float erro_ant;
float erro_ant2;
float res;
float res_ant;
float res_ant2;
float pr_out;
double c1;
double c2;
double c3;
double c4;
} sPR;

#define PR_default  {0,0,0,0,0,0,0,0,0,0.00005553931071838902,-0.00005553931071838902,-1.99824566019771654446,0.99999999999999977796}

sPR PRf_alfa = PR_default;
sPR PRf_beta = PR_default;

typedef struct {
float x;
float y;
float W;
float b0;
float b1;
float b2;
float b3;
float a1;
float a2;
float V_sogi;
float V_sogi1;
float V_sogi2;
float V_sogi_q;
float V_sogi_q1;
float V_sogi_q2;
float Vm;
float Vm1;
float Vm2;
float K_damp;
float freq_res;
} sSOGI;

#define SOGI_default {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1.414213562373095,60}

sSOGI SOGI1 = SOGI_default;
sSOGI SOGI2 = SOGI_default;

typedef struct{
float a;
float b;
float c;
} sABC;

#define ABC_default {0,0,0}

sABC Vabc = ABC_default;
sABC Vpwm_abc = ABC_default;
sABC Isabc = ABC_default;

typedef struct{
float alfa;
float beta;
} sAlfaBeta;

#define AlfaBeta_default {0,0}

sAlfaBeta Valfabeta = AlfaBeta_default;
sAlfaBeta Vpwm_alfabeta = AlfaBeta_default;
sAlfaBeta Ialfabeta = AlfaBeta_default;
sAlfaBeta Isalfabeta = AlfaBeta_default;

typedef struct{
float d;
float q;
} sDQ;

#define dq_default {0,0}

sDQ Vdq = dq_default;

typedef struct{
float Valfa_in;
float Vbeta_in;
float angle;
float angle_ant;
float pi_out_ant;
float wf;
} spll;

#define pll_default {0,0,0,0,0,376.99111843077}

spll PLL = pll_default;

typedef struct{
float array[150];
float x;
float y;
float y_ant;
int j;
} sMAV;
 
#define  MAV_default {{0},0,0,0,0}             
sMAV MAVP = MAV_default;
sMAV MAVQ = MAV_default;
sMAV MAVV = MAV_default;

typedef struct{
float x;
float x_ant;
float x_ant2;
float y;
float y_ant;
float y_ant2;
double c0;
double c1;
double c2;
double c3;
double c4;
} sFilter2nd;
 
#define  FILTER2ND_DEFAULTS {0,0,0,0,0,0,0.00042585082119787660,0.00085170164239575319,0.00042585082119787660,-1.94079521500497276243,0.94249861828976422284} //60Hz         
sFilter2nd fil2nVdc = FILTER2ND_DEFAULTS;
sFilter2nd fil2nPot = FILTER2ND_DEFAULTS;
sFilter2nd fil2nQ   = FILTER2ND_DEFAULTS;

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
#define PRamp_default {0,0,0,0,0,0,(6e3),(-6e3)} 
sRamp QRamp = PRamp_default;

//................Parametros do PWM
int count = 0;
int inc = 1;
int S1 = 0;
int S2 = 0;
int S3 = 0;
int S4 = 0;
int S5 = 0;
int S6 = 0;

//funções
//Filtro segunda ordem

void Second_order_filter(sFilter2nd *filt)
{
	filt->y = filt->x*filt->c0 + filt->x_ant*filt->c1 + filt->x_ant2*filt->c2 - filt->y_ant*filt->c3 - filt->y_ant2*filt->c4;
	filt->x_ant2 = filt->x_ant;
	filt->x_ant  = filt->x;
	filt->y_ant2 = filt->y_ant;
	filt->y_ant  = filt->y;
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

// SOGI
void SOGI_func(sSOGI *sog, float Tsample)
{
  sog->x =  4*Tsample*pi * sog->K_damp *  sog->freq_res;
  sog->y = (Tsample*2*pi * sog->freq_res)*(Tsample*2*pi * sog->freq_res);

  sog->b1 = sog->x + sog->y + 4;
  sog->b2 = sog->x - sog->y - 4;
  sog->b3 = 2*(4 - sog->y);

  sog->b0 = sog->x * (1/sog->b1);
  sog->a1 = sog->b3 * (1/sog->b1);
  sog->a2 = sog->b2 * (1/sog->b1);

  sog->W = 4*Tsample*pi * sog->freq_res;

  sog->V_sogi = sog->b0 * sog->Vm - sog->b0 * sog->Vm2 + sog->a1 * sog->V_sogi1+ sog->a2 * sog->V_sogi2;

  sog->V_sogi_q = sog->W * sog->b0 * sog->Vm1 + sog->V_sogi_q1 * sog->a1 + sog->V_sogi_q2 * sog->a2;
	
  sog->Vm2 = sog->Vm1;
  sog->Vm1 = sog->Vm;
	
  sog->V_sogi2 = sog->V_sogi1;
  sog->V_sogi1 = sog->V_sogi;
	 
  sog->V_sogi_q2 = sog->V_sogi_q1;
  sog->V_sogi_q1 = sog->V_sogi_q;
}

// Rampa
void Ramp(sRamp *rmp, float sample)
{
  if(rmp->uin != rmp->y) rmp->t1 = rmp->t1 + sample;
  else rmp->t1 = 0;
  rmp->rate = (rmp->uin - rmp->y_ant)/(rmp->t1 - rmp->t1_ant);
  if(rmp->rate > rmp->rising) rmp->y = (rmp->t1 - rmp->t1_ant)*rmp->rising + rmp->y_ant;
  else if(rmp->rate < rmp->falling) rmp->y = (rmp->t1 - rmp->t1_ant)*rmp->falling + rmp->y_ant;
  else rmp->y = rmp->uin;

  rmp->t1_ant = rmp->t1;
  rmp->y_ant = rmp->y;	
}


// Ressonante
void Resfunc(sPR *point_res, float Kp, float Kr)
{
 	point_res->res = point_res->c1*point_res->erro + point_res->c2*point_res->erro_ant2 - point_res->c3*point_res->res_ant - point_res->c4*point_res->res_ant2;
    point_res->res_ant2 = point_res->res_ant;
    point_res->res_ant = point_res->res;
    point_res->erro_ant2 = point_res->erro_ant;
    point_res->erro_ant = point_res->erro;

    point_res->pr_out = Kp*point_res->erro + Kr*point_res->res;
}    