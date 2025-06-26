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
  
  freq = 376.9911184; // Wn
 

  feedBack_Valfa = (VA - V_alfa) * 1.41421356;
  feedBack_Q_Valfa = feedBack_Valfa - Q_Valfa;
  integOne_in = feedBack_Q_Valfa * wn;

  //Integrador 1
  integOne_out = integOne_out_ant + (Ts/2)*(integOne_in_ant + integOne_in);
  
  integOne_in_ant = integOne_in;
  integOne_out_ant = integOne_out;

   integTwo_in = integOne_out;

  //Integrador 2
  integTwo_out = integTwo_out_ant + (Ts/2)*(integTwo_in_ant + integTwo_in) ;
  integTwo_in_ant = integTwo_in;
  integTwo_out_ant = integTwo_out;

  V_alfa = integTwo_in;

  Q_Valfa = integTwo_out * wn;

////////////////////////////////////////////////////////Transformada com integradores EM BETA/////////////////////////////////////


  feedBack_Vbeta = (VB - V_beta) * 1.41421356;
  feedBack_Q_Vbeta = feedBack_Vbeta - (Q_Vbeta);
  integOne_in_b = feedBack_Q_Vbeta * wn;

  //Integrador 1
  integOne_out_b = integOne_out_ant_b + (Ts/2)*(integOne_in_ant_b + integOne_in_b);
  integOne_in_ant_b = integOne_in_b;
  integOne_out_ant_b = integOne_out_b;

  integTwo_in_b = integOne_out_b;

  //Integrador 2
  integTwo_out_b = integTwo_out_ant_b + (Ts/2)*(integTwo_in_ant_b + integTwo_in_b);
  integTwo_in_ant_b = integTwo_in_b;
  integTwo_out_ant_b = integTwo_out_b;
  
  V_beta = integTwo_in_b;

  Q_Vbeta = integTwo_out_b * wn;

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

Vabcn_a = V_alfa_b;
Vabcn_b = -0.5*V_alfa_b + 0.866025403784439*V_beta_b;
Vabcn_c = -0.5*V_alfa_b - 0.866025403784439*V_beta_b;



////////////////////////////////////////////////////////Angulos e Frequências PLL/////////////////////////////////////


// ALFA
comp_q_a = Vabcp_a * (-0.6666666666) * sin(theta_a) + Vabcp_b * sin(theta_a - 2.0943933333333) * (-0.6666666666) + Vabcp_c * sin(theta_a - 4.188786666666) * (-0.6666666666);
comp_d_a = Vabcp_a * cos(theta_a) * (0.6666666666) + Vabcp_b * cos(theta_a - 2.0943933333333) * (0.6666666666) + Vabcp_c * cos(theta_a - 4.188786666666) * (0.6666666666);

Fnc_a = comp_q_a/(sqrt(comp_d_a*comp_d_a + comp_q_a*comp_q_a + 1e-13));


// wn_srf1 = 20*2*pi;
// ki_pll = (30*2*pi)*30*2*pi

	
//Integrador 1
integOne_in_Fcn_a = Fnc_a * (Ki_pll);
integOne_out_Fcn_a = integOne_out_ant_Fcn_a + (Ts/2)*(integOne_in_ant_Fcn_a + integOne_in_Fcn_a);
integOne_in_ant_Fcn_a = integOne_in_Fcn_a;
integOne_out_ant_Fcn_a = integOne_out_Fcn_a;

omega_a = (integOne_out_Fcn_a + (Kp_pll * Fnc_a)) + wn;



//Integrador 2
integOne_in_Fcn_a1 = omega_a;

integOne_out_Fcn_a1 = integOne_out_ant_Fcn_a1 + (Ts/2)*(integOne_in_ant_Fcn_a1 + integOne_in_Fcn_a1);
integOne_in_ant_Fcn_a1 = integOne_in_Fcn_a1;
integOne_out_ant_Fcn_a1 = integOne_out_Fcn_a1;

theta_a = fmod(integOne_out_Fcn_a1,6.28318);


//BETA
comp_q_b = Vabcn_a * sin(theta_b) * (-0.6666666666) + Vabcn_b * sin(theta_b - 2.0943933333333) * (-0.6666666666) + Vabcn_c * sin(theta_b - 4.188786666666) * (-0.6666666666);
comp_d_b = Vabcn_a * cos(theta_b) * (0.6666666666) + Vabcn_b * cos(theta_b - 2.0943933333333) * (0.6666666666) + Vabcn_c * cos(theta_b - 4.188786666666) * (0.6666666666);

Fnc_b = comp_q_b/(sqrt(comp_d_b*comp_d_b + comp_q_b*comp_q_b + 1e-13));


// wn_srf1 = 20*2*pi;
// ki_pll = (30*2*pi)*30*2*pi = (188.4954)*(188.4954);

//Integrador 1 (One_b)
integOne_in_Fcn_b = Fnc_b * (Ki_pll);

integOne_out_Fcn_b = integOne_out_ant_Fcn_b + (Ts/2)*(integOne_in_ant_Fcn_b + integOne_in_Fcn_b);
integOne_in_ant_Fcn_b = integOne_in_Fcn_b;
integOne_out_ant_Fcn_b = integOne_out_Fcn_b;

omega_b = (integOne_out_Fcn_b + (Kp_pll*Fnc_b)) + wn;


//Integrador 2 (One_b1)
integOne_in_Fcn_b1 = omega_b;

integOne_out_Fcn_b1 = integOne_out_ant_Fcn_b1 + (Ts/2)*(integOne_in_ant_Fcn_b1 + integOne_in_Fcn_b1) ;
integOne_in_ant_Fcn_b1 = integOne_in_Fcn_b1;
integOne_out_ant_Fcn_b1 = integOne_out_Fcn_b1;

theta_b = fmod(integOne_out_Fcn_b1,6.28318);



Output(0) = Vabcp_a;
Output(1) = Vabcp_b;
Output(2) = Vabcp_c;
Output(3) = Vabcn_a;
Output(4) = Vabcn_b;
Output(5) = Vabcn_c;
Output(6) = theta_a;
Output(7) = theta_b;
Output(8) = comp_d_a;
Output(9) = comp_q_a;
