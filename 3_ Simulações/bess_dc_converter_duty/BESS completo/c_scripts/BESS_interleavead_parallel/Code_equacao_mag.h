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
// #define SELECAO (int) ParamRealData(2,0)

// float kp_pos;
// float kp_neg;
// float kq_pos;
// float kq_neg;
// int selec = 0;
#define kp_pos 1
#define kp_neg 0
#define kq_pos 1
#define kq_neg 0

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