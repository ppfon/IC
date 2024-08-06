//..............Contador Para a interrupção e PWM
count_0 = count_0 + inc;
count_120 = count_120 + inc_120;
count_240 = count_240 + inc_240;
teste = 0;

if(count_0 == PRD) inc = -1;
if(count_0 == 0) inc = 1;

if(count_120 == PRD) inc_120 = -1;
if(count_120 == 0) inc_120 = 1;

if(count_240 == PRD) inc_240 = -1;
if(count_240 == 0) inc_240 = 1;

CMPB = 0;

//............................................................Interrupções.....................................................................................................]...
if(pulse_on == 1)
{
  PIbt.enab = 1;
  PIbt2.enab = 1;
  PIbt3.enab = 1;
  PIbu.enab = 1;
  PIbu2.enab = 1;
  PIbu3.enab = 1;
  PIbt_vout.enab = 1;
  PIbu_vout.enab = 1;

  //////////////////////////////////////////////////////////////////////Mudança do modo de operação pelas flags/////////////////////////////////////  
  //Reseta para Descarga (1) e Carga (2)
  if(Pref > 0)
  {
    flag.DM = 1;               //Habilita Descarga
    flag.CM = 0;               //Desabilita Carga
  }

  else if(Pref < 0)
  {
    flag.DM = 0;               //Desabilita Descarga
    flag.CM = 1;               //Aciona o modo de carga
  }

  else if(Pref == 0)
  {
    flag.DM = 0;
    flag.CM = 0;               
  }

}

else
{
  PIbt.enab = 0;
  PIbt2.enab = 0;
  PIbt3.enab = 0;
  PIbu.enab = 0;
  PIbu2.enab = 0;
  PIbu3.enab = 0;
  PIbt_vout.enab = 0;
  PIbu_vout.enab = 0;

  VoutRamp.uin = Filt_freq_Vdc.Yn;
  VoutRamp.y = Filt_freq_Vdc.Yn;
}

///////////////////////////////////////////////////Interrupção 1
if(count_0 == CMPB)
{
  //Rampa da referência
  Ramp(&VoutRamp, Ts);

  //Filtragem do Vdc medido
  Filt_freq_Vdc.Un = Vdc;
  First_order_signals_filter(&Filt_freq_Vdc);

  ////////////////////////////////////////////////////////////////Inicia Descarga(INT1)///////////////////////////////////////////////////////////////
  if(flag.DM == 1)
  {
    VoutRamp.uin = Vref_dis;

    PIbt_vout.Xref = VoutRamp.y;
    PIbt_vout.Xm = Filt_freq_Vdc.Yn;

    Pifunc(&PIbt_vout, Ts/2, Kp_vout, Ki_vout, 18, -18);                   // Controle 

    //Rampa de corrente
    PIbt.Xref = PIbt_vout.piout_sat / 3;
    PIbt.Xm = Ibat;                                    // Corrente medida para o modo boost (Descarga)
    
    Pifunc(&PIbt, Ts/2, Kpbt, Kibt, sat_up, sat_down);                   // Controle PI

    PIbt.duty = PIbt.piout_sat*PRD;                    // Saída do controlador -> duty
  } //fecha DCM


  /////////////////////////////////Inicia Carga (INT1)//////////
  //Carga
  if(flag.CM == 1)
  { 
    VoutRamp.uin = Vref_ch;       
    ///////////////////Malha externa de controle da tensão
    ///controle
    PIbu_vout.Xref = VoutRamp.y;
    PIbu_vout.Xm = Filt_freq_Vdc.Yn;

    Pifunc(&PIbu_vout, Ts/2, Kp_vout, Ki_vout, 7, -7);                   // 

    PIbu.Xref = - PIbu_vout.piout_sat / 3;

    PIbu.Xm   = -Ibat;                                

    Pifunc(&PIbu, Ts/2, Kpibu, Kiibu, sat_up, sat_down);                   // Controle PI

    PIbu.duty = PIbu.piout_sat*PRD;                    // Saída do controlador -> duty
  }// fecha CCM

} //Fecha interrupção1

///////////////////////////////////////////////////Interrupção 2
if(count_120 == CMPB)
{
  ////////////////////////////////////////////////////////////////Inicia Descarga(INT1)///////////////////////////////////////////////////////////////
  if(flag.DM == 1)
  {
    PIbt2.Xref = PIbt.Xref;
    PIbt2.Xm = Ibat2;                                   //Corrente medida para o modo boost (Descarga)
    
    Pifunc(&PIbt2, Ts/2, Kpbt, Kibt, sat_up, sat_down);                   // Controle PI

    PIbt2.duty = PIbt2.piout_sat*PRD;                   // Saída do controlador -> duty
  } //fecha DCM

    ////////////////////////////////////////////////////////////////Inicia Carga (INT2)///////////////////////////////////////////////////////////////
    //Carga a corrente constante
  if(flag.CM == 1)
  {

    PIbu2.Xref = PIbu.Xref;
    PIbu2.Xm = -Ibat2;                                             

    Pifunc(&PIbu2, Ts/2, Kpibu, Kiibu, sat_up, sat_down);                   // Controle PI

    PIbu2.duty = PIbu2.piout_sat*PRD;                    // Saída do controlador -> duty
  }// fecha CCM
}//Fecha interrupção2

///////////////////////////////////////////////////Interrupção 3
if(count_240 == CMPB)
{
  ////////////////////////////////////////////////////////////////Inicia Descarga(INT1)///////////////////////////////////////////////////////////////
  if(flag.DM == 1)
  {
    PIbt3.Xref = PIbt.Xref;
    PIbt3.Xm = Ibat3;                                               //Corrente medida para o modo boost (Descarga)
    
    Pifunc(&PIbt3, Ts/2, Kpbt, Kibt, sat_up, sat_down);                   // Controle PI

    PIbt3.duty = PIbt3.piout_sat*PRD;                    // Saída do controlador -> duty
  } //fecha DCM


/////////////////////////////////////////////Inicia Carga (INT3)//////////////
  //Carga a corrente constante
  if(flag.CM == 1)
  {
    PIbu3.Xref = PIbu.Xref;
    PIbu3.Xm   = -Ibat3;                              
    
    Pifunc(&PIbu3, Ts/2, Kpibu, Kiibu, sat_up, sat_down);                   // Controle PI

    PIbu3.duty = PIbu3.piout_sat*PRD;                    // Saída do controlador -> duty
  }// fecha CCM
}//Fecha interrupção3

//..........PWM do conversor boost (Carga)

if(flag.CM == 1 && pulse_on == 1)
{
  if(PIbu.duty >= count_0)  
  { 
    S2 = 0;
    S1 = 1;
  } 
  else  
  {
    S2 = 0;
    S1 = 0;
  }

  if(PIbu2.duty >= count_120)  
  { 
    S4 = 0;
    S3 = 1;
  } 
  else  
  {
    S4 = 0;
    S3 = 0;
  }

  if(PIbu3.duty >= count_240)  
  { 
    S6 = 0;
    S5 = 1;
  } 
  else  
  {
    S6 = 0;
    S5 = 0;
  }

}
else if(flag.DM == 1 && pulse_on == 1)
{
  //..........PWM do conversor boost (Descarga)
  if(PIbt.duty >= count_0)  
  { 
    S2 = 1;
    S1 = 0;
  } 
  else  
  {
    S2 = 0;
    S1 = 0;
  }

  if(PIbt2.duty >= count_120)  
  { 
    S4 = 1;
    S3 = 0;
  } 
  else  
  {
    S4 = 0;
    S3 = 0;
  }

  if(PIbt3.duty >= count_240)  
  { 
    S6 = 1;
    S5 = 0;
  } 
  else  
  {
    S6 = 0;
    S5 = 0;
  }

}
else
{
  S1 = 0;
  S2 = 0;
  S3 = 0;
  S4 = 0;
  S5 = 0;
  S6 = 0;
}

Output(0) = PIbt_vout.Xref;
Output(1) = PIbt_vout.Xm;
Output(2) = PIbt.Xref;
Output(3) = PIbt.Xm;
Output(4) = PIbt2.Xm;
Output(5) = PIbt3.Xm;
Output(6) = S1;
Output(7) = S2;
Output(8) = S3;
Output(9) = S4;
Output(10) = S5;
Output(11) = S6;
Output(12) = PIbu_vout.Xref;
Output(13) = PIbu_vout.Xm;
Output(14) = PIbu.Xref;
Output(15) = PIbu.Xm;
Output(16) = PIbu.piout_sat;
Output(17) = PIbu2.piout_sat;
Output(18) = PIbu3.piout_sat;
Output(19) = count_0;
Output(20) = count_120;
Output(21) = count_240;

