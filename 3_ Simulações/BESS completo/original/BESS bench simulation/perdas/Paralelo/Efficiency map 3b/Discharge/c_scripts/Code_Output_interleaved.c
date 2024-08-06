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

//............................................................Interrupções........................................................................................................
if(control_enable == 1)
{
  ///////////////////////////////////////////////////Interrupção 1
  if(count_0 == CMPB)
  {
    //////////////////////////////////////////////////////////////////////Mudança do modo de operação pelas flags/////////////////////////////////////  
    //Reseta para Descarga (1) e Carga (2)
    if(reset == 1)
    {
      flag.DM = 1;               //Habilita Descarga
      flag.CM = 0;               //Desabilita Carga
      //Rampa de potência
      PRamp.final = Pref;
      PRamp.in = Vbat*(Ibat+Ibat2+Ibat3);
   
      flag.BVCM = 0;
    }

    if(reset == 2)
    {
      flag.DM = 0;               //Desabilita Descarga
      flag.CM = 1;               //Aciona o modo de carga
   
      if(flag.BVCM == 0)
      {
        Vref = Vboost*Nb_series;   //seta a referência de tensão para a tensão de boost
        VRamp.final = Vref;
        VRamp.in = Vbat;
        if(Vbat >= Vboost*Nb_series) flag.BVCM = 1; // Tensão de boost atingida
      }
      //Comuta para tensão de float: Importante, flag.BVCM precista está zerado por default no ligamento da bancada e zerado quando para de chaver. Isto é necessário para que se a carga for novamanete ativada, o ciclo se repita
      if(flag.BVCM == 1  && (Ibat+Ibat2+Ibat3) >= -0.1*Iref_ch) 
      { 
        Vref = Vfloat*Nb_series;   //seta a referência de tensão para a tensão de float
        VRamp.final = Vref;
        VRamp.in = Vbat;
      }
    }

    //Rampa da referência de I
    Ramp(&PRamp);
    Ramp(&VRamp);

    ////////////////////////////////////////////////////////////////Inicia Descarga(INT1)///////////////////////////////////////////////////////////////
    if(flag.DM == 1)
    {
      // Controle de potência
      PIp.Xref = Pref;
      PIp.Xm = Vbat*(Ibat+Ibat2+Ibat3);

      Pifunc(&PIp, Ts/2, Kpp, Kip, 250, -250);                   // Controle 

      //Controle de corrente
      PIbt.Xref = PIp.piout_sat/N_br;
      PIbt.Xm = Ibat;                                    // Corrente medida para o modo boost (Descarga)
      
      Pifunc(&PIbt, Ts/2, Kpbt, Kibt, sat_up, sat_down);                   // Controle PI

      PIbt.duty = PIbt.piout_sat*PRD;                    // Saída do controlador -> duty
    } //fecha DCM

    else
    {
      PRamp.final = 0;
    }

    ////////////////////////////////////////////////////////////////Inicia Carga (INT1)///////////////////////////////////////////////////////////////
    //Carga
    if(flag.CM == 1)
    {        
      /////////////////////Malha externa de controle da tensão
      ///controle
      PIbuv.Xref = VRamp.atual;
      PIbuv.Xm   = Vbat;                                     //Tensão medida para o modo buck (carga)           
      
      Pifunc(&PIbuv, Ts/2, Kpvbu, Kivbu, Iref_ch/N_br, -10);   // Controle PI
  
      PIbu.Xref = PIbuv.piout_sat;

      PIbu.Xm   = -Ibat;                                   //Corrente medida para o modo boost (Descarga)

      Pifunc(&PIbu, Ts/2, Kpibu, Kiibu, sat_up, sat_down);                   // Controle PI

      PIbu.duty = PIbu.piout_sat*PRD;                    // Saída do controlador -> duty
    }// fecha CCM

    else
    {
      VRamp.final = 0;
    }
  } //Fecha interrupção1

  ///////////////////////////////////////////////////Interrupção 2
  if(count_120 == CMPB)
  {       
    ////////////////////////////////////////////////////////////////Inicia Descarga(INT1)///////////////////////////////////////////////////////////////
    if(flag.DM == 1)
    {
      PIbt2.Xref = PIp.piout_sat/N_br;
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

      PIbu2.duty = PIbu2.piout_sat*PRD;            // Saída do controlador -> duty
    }// fecha CCM
  }//Fecha interrupção2

  ///////////////////////////////////////////////////Interrupção 3
  if(count_240 == CMPB)
  {
    ////////////////////////////////////////////////////////////////Inicia Descarga(INT1)///////////////////////////////////////////////////////////////
    if(flag.DM == 1)
    {
      PIbt3.Xref = PIp.piout_sat/N_br;
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


  if(flag.DM == 1)
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

}//fecha control enable

Output(0) = PIp.Xref;
Output(1) = PIp.Xm;
Output(2) = PIbt.Xref;
Output(3) = PIbt.Xm;
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
Output(17) = count_0;
Output(18) = count_120;
Output(19) = count_240;

