#include <math.h>

#define Vga Input (0)
#define Vgb Input (1)
#define Vgc Input (2)

#define fsw     ParamRealData(0,0)    
#define Ts      ParamRealData(1,0)   
#define fdsp    ParamRealData(2,0)  
#define Kpouter ParamRealData(3,0)  
#define Kiouter ParamRealData(4,0)  
#define Kp_pll  ParamRealData(5,0)
#define Ki_pll  ParamRealData(6,0)
#define Kp_res  ParamRealData(7,0)
#define fn		ParamRealData(8,0)
#define wn      ParamRealData(9,0)

float Vabc_a=0;
float Vabc_b=0;
float Vabc_c=0;
float Valfabeta_alfa=0;
float Valfabeta_beta=0;
float VA=0;
float VB=0;
float freq=0;
float Vabcp_a=0;
float Vabcp_b=0;
float Vabcp_c=0;
float Vabcn_a=0;
float Vabcn_b=0;
float Vabcn_c=0;
//float fsw;
//float Ts;
float integOne_out =0;
float integOne_out_ant=0;
float integOne_in_ant=0;
float integOne_in=0;
float integTwo_out=0;
float integTwo_out_ant=0;
float integTwo_in_ant=0;
float integTwo_in=0;
float feedBack_Valfa=0;
float feedBack_Q_Valfa=0;
float V_alfa=0;
float Q_Valfa=0;
float V_beta=0;
float Q_Vbeta=0;
float feedBack_Vbeta=0;
float feedBack_Q_Vbeta=0;
float integOne_out_b=0;
float integOne_out_ant_b=0;
float integOne_in_ant_b=0;
float integOne_in_b=0;
float integTwo_out_b=0;
float integTwo_out_ant_b=0;
float integTwo_in_ant_b=0;
float integTwo_in_b=0;
float V_alfa_a;
float V_beta_a;
float V_alfa_b;
float V_beta_b;


//Angulos e Frequências PLL 
float comp_d_a=0;
float comp_q_a=0;
float theta_a=0;
float Fnc_a=0;
float integOne_in_Fcn_a=0;
float integOne_out_Fcn_a=0;
float integOne_in_ant_Fcn_a=0;
float integOne_out_ant_Fcn_a=0;
float omega_a=0;

float integOne_in_Fcn_a1=0;
float integOne_out_Fcn_a1=0;
float integOne_out_ant_Fcn_a1=0;
float integOne_in_ant_Fcn_a1=0;

float comp_d_b=0;
float comp_q_b=0;
float theta_b=0;
float Fnc_b=0;
float integOne_in_Fcn_b=0;
float integOne_out_Fcn_b=0;
float integOne_in_ant_Fcn_b=0;
float integOne_out_ant_Fcn_b=0;
float omega_b=0;

float integOne_in_Fcn_b1=0;
float integOne_out_Fcn_b1=0;
float integOne_out_ant_Fcn_b1=0;
float integOne_in_ant_Fcn_b1=0;