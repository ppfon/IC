//..............Contador Para a interrupção e PWM
count0 = count0 + inc;
count1 = count1 + inc1;
count2 = count2 + inc2;
teste = 0;

if(count0 == PRD) inc = -1;
if(count0 == 0)   inc = 1;

if(N_br_ant != 1)
{
  if(count1 == PRD) inc1 = -1;
  if(count1 == 0)   inc1 = 1;
}
else{
  count1 = 0;
  inc1 = 0;
}

if(N_br_ant == 3)
{
  if(count2 == PRD) inc2 = -1;
  if(count2 == 0)   inc2 = 1;
}
else{
  count2 = 0;
  inc2 = 0;
}


CMPB = 0;

//............................................................Interrupções........................................................................................................
if(control_enable == 1)
{
  if((N_br == 3) && (N_br != N_br_ant))
  {
    N_br_ant = 3;
    count0 = 61;
    count1 = 19;
    count2 = 21;
    inc  = -1;
    inc1 = 1;
    inc2 = -1;
  }

  if(N_br == 2 && N_br != N_br_ant)
  {
    N_br_ant = 2;
    count0 = 0;
    count1 = 60;
    count2 = 0;
    inc = 1;
    inc1 = -1;
    inc2 = 0;
  }

  if(N_br == 1 && N_br != N_br_ant)
  {
    N_br_ant = 1;
    count1 = 0;
    count2 = 0;
    inc = 1;
    inc1 = 0;
    inc2 = 0;
  }
  ///////////////////////////////////////////////////Interrupção 1
  if(count0 == CMPB)
  {
    //////////////////////////////////////////////////////////////////////Mudança do modo de operação pelas flags/////////////////////////////////////  
    //Reseta para Descarga (1) e Carga (2)
    if(reset == 1)
    {
      flag.DM = 1;               //Habilita Descarga
      flag.CM = 0;               //Desabilita Carga
      //Rampa de corrente
      IRamp_bt.uin = Iref_dis/N_br;
      IRamp2_bt.uin = Iref_dis/N_br;
      IRamp3_bt.uin = Iref_dis/N_br;
   
      flag.BVCM = 0;
    }
    else
    {
      IRamp_bt.uin = (Ibat+Ibat2+Ibat3)/N_br;
      IRamp2_bt.uin = IRamp_bt.uin;
      IRamp3_bt.uin = IRamp_bt.uin;      
    }

    if(reset == 2)
    {
      flag.DM = 0;               //Desabilita Descarga
      flag.CM = 1;               //Aciona o modo de carga
   
      if(flag.BVCM == 0)
      {
        Vref = Vboost*Nb_series;   //seta a referência de tensão para a tensão de boost
        VRamp.uin = Vref;
        if(Vbat >= Vboost*Nb_series) flag.BVCM = 1; // Tensão de boost atingida
      }
      //Comuta para tensão de float: Importante, flag.BVCM precista está zerado por default no ligamento da bancada e zerado quando para de chaver. Isto é necessário para que se a carga for novamanete ativada, o ciclo se repita
      if(flag.BVCM == 1  && (Ibat+Ibat2+Ibat3) >= -0.1*Iref_ch) 
      { 
        Vref = Vfloat*Nb_series;   //seta a referência de tensão para a tensão de float
        VRamp.uin = Vref;
      }
    }
    else
    {
      VRamp.uin = Vbat;
    }

    //Rampa da referência de I
    Ramp(&IRamp_bt, Ts);
    Ramp(&VRamp, Ts);

    ////////////////////////////////////////////////////////////////Inicia Descarga(INT1)///////////////////////////////////////////////////////////////
    if(flag.DM == 1)
    {
      //Rampa de corrente
      PIbt.Xref = IRamp_bt.y;
      PIbt.Xm = Ibat;                                    // Corrente medida para o modo boost (Descarga)
      
      Pifunc(&PIbt, Ts/2, Kpbt, Kibt, sat_up, sat_down);                   // Controle PI

      PIbt.duty = PIbt.piout_sat*PRD;                    // Saída do controlador -> duty
    } //fecha DCM

    ////////////////////////////////////////////////////////////////Inicia Carga (INT1)///////////////////////////////////////////////////////////////
    //Carga
    if(flag.CM == 1)
    {        
      //////////////////////////////////////////////////////Malha externa de controle da tensão
      ///controle
      PIbuv.Xref = VRamp.y;
      PIbuv.Xm   = Vbat;                                     //Tensão medida para o modo buck (carga)           
      
      Pifunc(&PIbuv, Ts/2, Kpvbu, Kivbu, Iref_ch/3, -10);   // Controle PI
  
      PIbu.Xref = PIbuv.piout_sat;

      PIbu.Xm   = -Ibat;                                   //Corrente medida para o modo boost (Descarga)

      Pifunc(&PIbu, Ts/2, Kpibu, Kiibu, sat_up, sat_down);                   // Controle PI

      PIbu.duty = PIbu.piout_sat*PRD;                    // Saída do controlador -> duty
    }// fecha CCM
  } //Fecha interrupção1

  ///////////////////////////////////////////////////Interrupção 2
  if(count1 == CMPB && N_br_ant != 1)
  {
    //Rampa da referência de I
    Ramp(&IRamp2_bt, Ts);
       
    ////////////////////////////////////////////////////////////////Inicia Descarga(INT1)///////////////////////////////////////////////////////////////
    if(flag.DM == 1)
    {
      PIbt2.Xref = IRamp2_bt.y;
      PIbt2.Xm = Ibat2;                                   //Corrente medida para o modo boost (Descarga)
      
      Pifunc(&PIbt2, Ts/2, Kpbt, Kibt, sat_up, sat_down);                   // Controle PI

      PIbt2.duty = PIbt2.piout_sat*PRD;                   // Saída do controlador -> duty
    } //fecha DCM

      ////////////////////////////////////////////////////////////////Inicia Carga (INT2)///////////////////////////////////////////////////////////////
      //Carga a corrente constante
    if(flag.CM == 1)
    {

      PIbu2.Xref = PIbu.Xref;
      PIbu2.Xm = -Ibat2;                                               //Corrente medida para o modo boost (Descarga)
      
      Pifunc(&PIbu2, Ts/2, Kpibu, Kiibu, sat_up, sat_down);                   // Controle PI

      PIbu2.duty = PIbu2.piout_sat*PRD;                    // Saída do controlador -> duty
    }// fecha CCM
  }//Fecha interrupção2

  ///////////////////////////////////////////////////Interrupção 3
  if(count2 == CMPB && N_br_ant == 3)
  {
    //Rampa da referência de I
    Ramp(&IRamp3_bt, Ts);

    ////////////////////////////////////////////////////////////////Inicia Descarga(INT1)///////////////////////////////////////////////////////////////
    if(flag.DM == 1)
    {
      PIbt3.Xref = IRamp3_bt.y;
      PIbt3.Xm = Ibat3;                                               //Corrente medida para o modo boost (Descarga)
      
      Pifunc(&PIbt3, Ts/2, Kpbt, Kibt, sat_up, sat_down);                   // Controle PI

      PIbt3.duty = PIbt3.piout_sat*PRD;                    // Saída do controlador -> duty
    } //fecha DCM

    ////////////////////////////////////////////////////////////////Inicia Carga (INT3)///////////////////////////////////////////////////////////////
    //Carga a corrente constante
    if(flag.CM == 1)
    {
      PIbu3.Xref = PIbu.Xref;
      PIbu3.Xm   = -Ibat3;                                  //Corrente medida para o modo boost (Descarga)
     
      Pifunc(&PIbu3, Ts/2, Kpibu, Kiibu, sat_up, sat_down);                   // Controle PI

      PIbu3.duty = PIbu3.piout_sat*PRD;                    // Saída do controlador -> duty
    }// fecha CCM
  }//Fecha interrupção3

  //..........PWM do conversor boost (Carga)

  if(flag.CM == 1)
  {
   if(PIbu.duty >= count0)  
   { 
     S2 = 0;
     S1 = 1;
   } 
   else  
   {
     S2 = 0;
     S1 = 0;
   }

   if(PIbu2.duty >= count1 && N_br_ant != 1)  
   { 
     S4 = 0;
     S3 = 1;
   } 
   else  
   {
     S4 = 0;
     S3 = 0;
   }

   if(PIbu3.duty >= count2 && N_br_ant == 3)  
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


  if(flag.DM == 1)
  {
    //..........PWM do conversor boost (Descarga)
    if(PIbt.duty >= count0)  
    { 
      S2 = 1;
      S1 = 0;
    } 
    else  
    {
      S2 = 0;
      S1 = 0;
    }

    if(PIbt2.duty >= count1 && N_br_ant != 1)  
    { 
      S4 = 1;
      S3 = 0;
    } 
    else  
    {
      S4 = 0;
      S3 = 0;
    }

    if(PIbt3.duty >= count2 && N_br_ant == 3)  
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

}//fecha control enable

Output(0) = PIbt.Xref;
Output(1) = PIbt.Xm;
Output(2) = PIbt2.Xm;
Output(3) = PIbt3.Xm;
Output(4) = S1;
Output(5) = S2;
Output(6) = S3;
Output(7) = S4;
Output(8) = S5;
Output(9) = S6;
Output(10) = PIbuv.Xref;
Output(11) = PIbuv.Xm;
Output(12) = PIbu.Xref;
Output(13) = PIbu.Xm;
Output(14) = PIbt.piout_sat;
Output(15) = PIbt2.piout_sat;
Output(16) = PIbt3.piout_sat;
Output(17) = count0;
Output(18) = count1;
Output(19) = count2;
Output(20) = N_br_ant;

