#include <math.h>

#define mode Input (0)
#define Vdc_ref Input (1)
#define Iref1 Input (2)
#define Iref2 Input (3)
#define Vb1 Input (4)
#define Vb2 Input (5)

#define fsw     ParamRealData(0,0)    
#define Ts      ParamRealData(1,0)   
#define fdsp    ParamRealData(2,0)  

#define PRD  (fdsp/fsw)/2           						 // COntador Up e Down, PRD = (fdsp/fsw)/2 
#define PRD_div2  PRD/2              						 // PRD_div2 = PRD/2;
#define pi    3.141592653589793

int count = 0;
int inc = 1;

int t1 = 0;
int t2 = 0;
int b1 = 0;
int b2 = 0;

float Vdc1 = 0;
float Vdc2 = 0;