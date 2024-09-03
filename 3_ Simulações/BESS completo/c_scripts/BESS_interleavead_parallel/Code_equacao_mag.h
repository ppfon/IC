#include <math.h>

#define PI 3.14159265358979323846;

#define tempo Input (0)
#define u Input (1)
#define theta_pos Input (2)
#define theta_neg Input (3)
#define v_pos_mod Input (4)
#define v_neg_mod Input (5)

#define P_ref ParamRealData(0,0)
#define Q_ref ParamRealData(1,0)
#define SELECAO ParamRealData(2,0)

int kp_pos;
int kp_neg;
int kq_pos;
int kq_neg;
int selec;

float omega;

float p_mag;
float q_mag;
float p_inst;
float q_inst;

float termo1;
float termo2;
float termo3;
float termo4;
float termo5;
float termo6;
float termo7;
float termo8;