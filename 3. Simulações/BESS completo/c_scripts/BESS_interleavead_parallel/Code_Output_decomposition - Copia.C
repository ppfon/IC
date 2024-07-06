#include <math.h>

  ////////////////////////////////////////////////////////Transformada abc para alfa-beta da tensão da rede/////////////////////////////////////
  Vabc_a = Vga;
  Vabc_b = Vgb;
  Vabc_c = Vgc;

  Valfabeta_alfa = (0.66666667  * Vabc_a) - (0.33333334 *  Vabc_b) - (0.33333334*Vabc_c);
  Valfabeta_beta = 0.5773502692 *  Vabc_b - 0.5773502692 * Vabc_c;

////////////////////////////////////////////////////////Componente alfa e beta/////////////////////////////////////

VA = Valfabeta_alfa;
VB = Valfabeta_beta; 

////////////////////////////////////////////////////////Transformada com integradores EM ALFA/////////////////////////////////////
  
  freq = 377;
  //1/9000 = 1/Fsw
 

  feedBack_Valfa = (VA - V_alfa) * 1.41421356;
  feedBack_Q_Valfa = feedBack_Valfa - Q_Valfa;
  integOne_in = feedBack_Q_Valfa * freq;

  //Integrador 1
  integOne_out = integOne_out_ant + (Ts)*integOne_in_ant;
  integOne_in_ant = integOne_in;
  integOne_out_ant = integOne_out;

   integTwo_in = integOne_out;

  //Integrador 2
  integTwo_out = integTwo_out_ant + (Ts)*integTwo_in_ant;
  integTwo_in_ant = integTwo_in;
  integTwo_out_ant = integTwo_out;

  V_alfa = integTwo_in;

  Q_Valfa = integTwo_out * freq;

////////////////////////////////////////////////////////Transformada com integradores EM BETA/////////////////////////////////////


  feedBack_Vbeta = (VB - V_beta) * 1.41421356;
  feedBack_Q_Vbeta = feedBack_Vbeta - (Q_Vbeta);
  integOne_in_b = feedBack_Vbeta * freq;

  //Integrador 1
  integOne_out_b = integOne_out_ant_b + (Ts)*integOne_in_ant_b;
  integOne_in_ant_b = integOne_in_b;
  integOne_out_ant_b = integOne_out_b;

  integTwo_in_b = integOne_out_b;

  //Integrador 2
  integTwo_out_b = integTwo_out_ant_b + (Ts)*integTwo_in_ant_b;
  integTwo_in_ant_b = integTwo_in_b;
  integTwo_out_ant_b = integTwo_out_b;
  
  V_beta = integTwo_in_b;

  Q_Vbeta = integTwo_out_b * freq;

  ////////////////////////////////////////////////////////Relações ALFA-BETA/////////////////////////////////////

  V_alfa_a = (V_alfa - Q_Vbeta)*0.5;
  V_beta_a = (Q_Valfa + V_beta)*0.5;

  V_alfa_b = (V_alfa + Q_Vbeta)*0.5;
  V_beta_b = (V_beta - Q_Valfa )*0.5;


////////////////////////////////////////////////////////Transformada alfa-beta para  abc da tensão da rede/////////////////////////////////////
////////////////////////////////////////////////////////Sequências Positivas e Negativas/////////////////////////////////////


//declaradas no trecho das estrategias de controle
Vabcp_a = V_alfa_a;
Vabcp_b = -0.5*V_alfa_a + 0.866025403784439*V_beta_a;
Vabcp_c = -0.5*V_alfa_a - 0.866025403784439*V_beta_a;

Vabcn_a = V_beta_b;
Vabcn_b = -0.5*V_beta_b + 0.866025403784439*V_alfa_b;
Vabcn_c = -0.5*V_beta_b - 0.866025403784439*V_alfa_b;



////////////////////////////////////////////////////////Angulos e Frequências PLL/////////////////////////////////////


// ALFA
comp_d_a = Vabcp_a * theta_a * sin(-2/3) + Vabcp_b * (theta_a - 2*3.14159/3) * sin(-2/3) + Vabcp_c * (theta_a - 4*3.14159/4) * sin(-2/3);
comp_q_a = Vabcp_a * theta_a * cos(2/3) + Vabcp_b * (theta_a - 2*3.14159/3) * cos(2/3) + Vabcp_c * (theta_a - 4*3.14159/4) * cos(2/3);

Fnc_a = comp_q_a/(sqrt(comp_d_a*comp_d_a + comp_q_a*comp_q_a + 1e-13));


// wn_srf1 = 20*2*pi;
// ki_pll = (30*2*pi)*30*2*pi

	
//Integrador 1
integOne_in_Fcn_a = Fnc_a * (30*2*3.14159)*(30*2*3.14159);
integOne_out_Fcn_a = integOne_out_ant_Fcn_a + (Ts)*integOne_in_ant_Fcn_a;
integOne_in_ant_Fcn_a = integOne_in_Fcn_a;
integOne_out_ant_Fcn_a = integOne_out_Fcn_a;

omega_a = integOne_out_Fcn_a + (30*2*3.14159)*(30*2*3.14159) + (2*3.14159*60);

//Integrador 2
integOne_in_Fcn_a1 = omega_a;

integOne_out_Fcn_a1 = integOne_out_ant_Fcn_a1 + (Ts)*integOne_in_ant_Fcn_a1;
integOne_in_ant_Fcn_a1 = integOne_in_Fcn_a1;
integOne_out_ant_Fcn_a1 = integOne_out_Fcn_a1;

theta_a = fmod(integOne_out_Fcn_a1,2*3.14159);


//BETA
comp_d_b = (Vabcn_a * theta_b * sin(-2/3) ) + (Vabcn_b * (theta_b - 2*3.14159/3) * sin(-2/3)) + (Vabcn_c * (theta_b - 4*3.14159/4) * sin(-2/3));
comp_q_b = (Vabcn_a * theta_b * cos(2/3) ) + (Vabcn_b * (theta_b - 2*3.14159/3) * cos(2/3)) + (Vabcn_c * (theta_b - 4*3.14159/4) * cos(2/3));

Fnc_b = comp_q_b/(sqrt(comp_d_b*comp_d_b + comp_q_b*comp_q_b + 1e-13));


// wn_srf1 = 20*2*pi;
// ki_pll = (30*2*pi)*30*2*pi

//Integrador 1
integOne_in_Fcn_b = Fnc_b * (30*2*3.14159)*(30*2*3.14159);

integOne_out_Fcn_b = integOne_out_ant_Fcn_b + (Ts)*integOne_in_ant_Fcn_b;
integOne_in_ant_Fcn_b = integOne_in_Fcn_b;
integOne_out_ant_Fcn_b = integOne_out_Fcn_b;

omega_b = integOne_out_Fcn_b + (30*2*3.14159)*(30*2*3.14159) + (2*3.14159*60);


//Integrador 2
integOne_in_Fcn_b1 = omega_b;

integOne_out_Fcn_b1 = integOne_out_ant_Fcn_b1 + (Ts)*integOne_in_ant_Fcn_b1;
integOne_in_ant_Fcn_b1 = integOne_in_Fcn_b1;
integOne_out_ant_Fcn_b1 = integOne_out_Fcn_b1;

theta_b = fmod(integOne_out_Fcn_b1,2*3.14159);

/*
Output(0) = Vabcp_a;
Output(1) = Vabcp_b;
Output(2) = Vabcp_c;
Output(3) = 0;
Output(4) = 0;
Output(5) = 0;
Output(6) = feedBack_Valfa;
Output(7) = feedBack_Q_Valfa;
Output(8) = integOne_in;
Output(9) = integOne_out;
*/


Output(0) = Vabcp_a;
Output(1) = Vabcp_b;
Output(2) = Vabcp_c;
Output(3) = Vabcn_a;
Output(4) = Vabcn_b;
Output(5) = Vabcn_c;
Output(6) = V_alfa;
Output(7) = Q_Valfa;
Output(8) = V_beta;
Output(9) = integOne_in;
