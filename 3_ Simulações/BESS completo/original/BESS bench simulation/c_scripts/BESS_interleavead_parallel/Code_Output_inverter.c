//..............Contador Para a interrupção e PWM
count = count + inc;

if(count == PRD) inc = -1;
if(count == 0) inc = 1;

//............................................................Interrupção........................................................................................................
if(count == PRD)
{

  ////////////////////////////////////////////////////////Transformada abc para alfa-beta da tensão da rede/////////////////////////////////////
  Vabc.a = Vga;
  Vabc.b = Vgb;
  Vabc.c = Vgc;

  //Valfabeta.alfa = 0.816496580927726 * (Vabc.a - 0.5*Vabc.b - 0.5*Vabc.c);
  //Valfabeta.beta = 0.816496580927726 * (0.866025403784439*Vabc.b - 0.866025403784439*Vabc.c);

  Valfabeta.alfa = 0.66666667   * (Vabc.a - 0.5*Vabc.b - 0.5*Vabc.c);
  Valfabeta.beta = 0.5773502692 * (Vabc.b - Vabc.c);

  ////////////////////////////////////////////////////////Transformada abc para alfa-beta da corrente do inversor/////////////////////////////////////
  Isabc.a = Isa;
  Isabc.b = Isb;
  Isabc.c = Isc;

  //Isalfabeta.alfa = 0.816496580927726 * (Isabc.a - 0.5*Isabc.b - 0.5*Isabc.c);
  //Isalfabeta.beta = 0.816496580927726 * (0.866025403784439*Isabc.b - 0.866025403784439*Isabc.c);

  Isalfabeta.alfa = 0.66666667 * (Isabc.a - 0.5*Isabc.b - 0.5*Isabc.c);
  Isalfabeta.beta = 0.5773502692 * (Isabc.b - Isabc.c);

  ////////////////////////////////////////////////////////DSOGI-PLL////////////////////////////////////////////////////////////////////////////////
  if(count_pll >= 1000){
    SOGI1.freq_res = (PIpll.piout_sat + PLL.wf)/(2*pi);  //Adaptativo
    SOGI2.freq_res = (PIpll.piout_sat + PLL.wf)/(2*pi);  //Adaptativo
  }
  else{
    count_pll++;
    SOGI1.freq_res = 60;
    SOGI2.freq_res = 60;
  }

  ////Sogi para a componente alfa da tensão
  SOGI1.Vm = Valfabeta.alfa;

  SOGI_func(&SOGI1, Ts);

  ////Sogi para a componente beta da tensão
  SOGI2.Vm = Valfabeta.beta;

  SOGI_func(&SOGI2, Ts);

  ///////////////////////////////////////////////PLL
  // Cálculo da Seq positiva
  PLL.Valfa_in = 0.5*(SOGI1.V_sogi-SOGI2.V_sogi_q);
  PLL.Vbeta_in = 0.5*(SOGI2.V_sogi+SOGI1.V_sogi_q);

  // Transformada alfabeta-dq da tensão
  Vdq.d = PLL.Valfa_in*cos(PLL.angle) + PLL.Vbeta_in*sin(PLL.angle);
  Vdq.q = PLL.Vbeta_in*cos(PLL.angle) - PLL.Valfa_in*sin(PLL.angle);

  // Normalização pelo pico da tensão da rede
  PIpll.Xref = 0;
  PIpll.Xm = -Vdq.q/(sqrt(Vdq.q*Vdq.q + Vdq.d*Vdq.d) + 1e-2);                                 
      
  Pifunc(&PIpll, Ts/2, Kp_pll, Ki_pll, 500, -500);                   // Controle PI

  // Integrador da PLL para o cálculo do ângulo. Método de integração (Foward)
  PLL.angle = PLL.angle_ant + Ts*PLL.pi_out_ant;
  PLL.pi_out_ant = PIpll.piout_sat + PLL.wf;
  if(PLL.angle > 6.283185307179586)  PLL.angle -= 6.283185307179586;
  if(PLL.angle < 0.0)  PLL.angle += 6.283185307179586;
  PLL.angle_ant = PLL.angle;

  //Medição pot ativa Injetada
  Pc = 1.224744871391589*PLL.Valfa_in*1.224744871391589*Isalfabeta.alfa + 1.224744871391589*PLL.Vbeta_in*1.224744871391589*Isalfabeta.beta;
  fil2nPot.x  = Pc;

  Second_order_filter(&fil2nPot);

  //Medição pot reativa Injetada
  Qc = 1.224744871391589*PLL.Vbeta_in*1.224744871391589*Isalfabeta.alfa - 1.224744871391589*PLL.Valfa_in*1.224744871391589*Isalfabeta.beta;

  fil2nQ.x = Qc;

  Second_order_filter(&fil2nQ);

  //Filtragem do Vdc medido
  fil2nVdc.x = Vdc;
  Second_order_filter(&fil2nVdc);

  //////////////////////////////////////////////////////////Controle de tensão do link cc///////////////////////////////////////////////////////////////////////qq
  if(control_enable == 1)
  {
    //Controle
    PIvdc.Xref = Vdc_ref*Vdc_ref;
    PIvdc.Xm   = fil2nVdc.y*fil2nVdc.y;                                               //Corrente medida para o modo boost (Descarga)
    
    Pifunc(&PIvdc, Ts/2, Kpouter, Kiouter, psat, -psat);                   // Controle PI

    //////////////////////////////////////////////////////////Controle do Reativo///////////////////////////////////////////////////////////////////////
    QRamp.uin = Qref;

    Ramp(&QRamp, Ts);
        
    PIq.Xref = QRamp.y;
    PIq.Xm   = fil2nQ.y; 

    Pifunc(&PIq, Ts/2, 0.001, Kiq, psat, -psat);      //Kp = 0, porém, para não dar erro no antiwindup foi colocado um valor pequeno (0.001)

    Q_control = (PIq.piout_sat + PIq.Xref) / 1.5;

    P_control = (-PIvdc.piout_sat) / 1.5; 

    /////////////////////////////////////////////////////////////Teoria da potência instantânea//////////////////////////////////
    PRf_alfa.Xref = (PLL.Valfa_in*(P_control) + Q_control*PLL.Vbeta_in)/(PLL.Valfa_in*PLL.Valfa_in + PLL.Vbeta_in*PLL.Vbeta_in + 1e-2);
    PRf_beta.Xref = (PLL.Vbeta_in*(P_control) - Q_control*PLL.Valfa_in)/(PLL.Valfa_in*PLL.Valfa_in + PLL.Vbeta_in*PLL.Vbeta_in + 1e-2);

    // saturação da corrente
    if(PRf_alfa.Xref>Ir) PRf_alfa.Xref = Ir;
    if(PRf_alfa.Xref<-Ir) PRf_alfa.Xref = -Ir;
    if(PRf_beta.Xref > Ir) PRf_beta.Xref = Ir;
    if(PRf_beta.Xref <-Ir) PRf_beta.Xref = -Ir;

    /////////////////////////////////////////////////////////Controladores ressonantes////////////////////////////////////////////////////////////

    // Componente Alfa
    PRf_alfa.Xm = Isalfabeta.alfa;

    PRf_alfa.erro = PRf_alfa.Xref - PRf_alfa.Xm;

    Resfunc(&PRf_alfa, Kp_res, Ki_res);

    // Componente Beta
    PRf_beta.Xm = Isalfabeta.beta;

    PRf_beta.erro = PRf_beta.Xref - PRf_beta.Xm;

    Resfunc(&PRf_beta, Kp_res, Ki_res);

    ///////////////////////////////////////////////Transformada abc para alfabeta da tensão de referência////////////////////////////////////
    Vpwm_alfabeta.alfa = PRf_alfa.pr_out + PLL.Valfa_in;
    Vpwm_alfabeta.beta = PRf_beta.pr_out + PLL.Vbeta_in;

    // Malha aberta
    //Vpwm_alfabeta.alfa = 50*cos(PLL.angle);
    //Vpwm_alfabeta.beta = 50*sin(PLL.angle);

    //Vpwm_abc.a = 0.816496580927726*Vpwm_alfabeta.alfa;
    //Vpwm_abc.b = 0.816496580927726*(-0.5*Vpwm_alfabeta.alfa + 0.866025403784439*Vpwm_alfabeta.beta);
    //Vpwm_abc.c = 0.816496580927726*(-0.5*Vpwm_alfabeta.alfa - 0.866025403784439*Vpwm_alfabeta.beta);

    Vpwm_abc.a = Vpwm_alfabeta.alfa;
    Vpwm_abc.b = -0.5*Vpwm_alfabeta.alfa + 0.866025403784439*Vpwm_alfabeta.beta;
    Vpwm_abc.c = -0.5*Vpwm_alfabeta.alfa - 0.866025403784439*Vpwm_alfabeta.beta;

    ////////////////////////////////////////////////Normalização pela tensão do barramento cc////////////////////////////////////
    Vpwm_norm_a = Vpwm_abc.a*1.732050807568877/fil2nVdc.y;
    Vpwm_norm_b = Vpwm_abc.b*1.732050807568877/fil2nVdc.y;
    Vpwm_norm_c = Vpwm_abc.c*1.732050807568877/fil2nVdc.y;

    if(Vpwm_norm_a > 1) Vpwm_norm_a = 1;
    if(Vpwm_norm_a < -1) Vpwm_norm_a = -1;
    if(Vpwm_norm_b > 1) Vpwm_norm_b = 1;
    if(Vpwm_norm_b < -1) Vpwm_norm_b = -1;
    if(Vpwm_norm_c > 1) Vpwm_norm_c = 1;
    if(Vpwm_norm_c < -1) Vpwm_norm_c = -1;

    //Cálculo da seq zero para o SVPWM
    if(Vpwm_norm_a<Vpwm_norm_b && Vpwm_norm_a<Vpwm_norm_c && Vpwm_norm_b>Vpwm_norm_c) 
    {
      vmin = Vpwm_norm_a;
      vmax = Vpwm_norm_b;
    }  
    else if(Vpwm_norm_a<Vpwm_norm_b && Vpwm_norm_a<Vpwm_norm_c && Vpwm_norm_c>Vpwm_norm_b) 
    {
      vmin = Vpwm_norm_a;
      vmax = Vpwm_norm_c;
    }  
    else if(Vpwm_norm_b<Vpwm_norm_a && Vpwm_norm_b<Vpwm_norm_c && Vpwm_norm_a>Vpwm_norm_c) 
    {
      vmin = Vpwm_norm_b;
      vmax = Vpwm_norm_a;
    }  
    else if(Vpwm_norm_b<Vpwm_norm_a && Vpwm_norm_b<Vpwm_norm_c && Vpwm_norm_c>Vpwm_norm_a) 
    {
      vmin = Vpwm_norm_b;
      vmax = Vpwm_norm_c;
    } 
    else if(Vpwm_norm_c<Vpwm_norm_a && Vpwm_norm_c<Vpwm_norm_b && Vpwm_norm_a>Vpwm_norm_b) 
    {
      vmin = Vpwm_norm_c;
      vmax = Vpwm_norm_a;
    } 
    else if(Vpwm_norm_c<Vpwm_norm_a && Vpwm_norm_c<Vpwm_norm_b && Vpwm_norm_b>Vpwm_norm_a) 
    {
      vmin = Vpwm_norm_c;
      vmax = Vpwm_norm_b;
    } 

    vsa_svpwm = -0.5*(vmin+vmax)+Vpwm_norm_a;
    vsb_svpwm = -0.5*(vmin+vmax)+Vpwm_norm_b;
    vsc_svpwm = -0.5*(vmin+vmax)+Vpwm_norm_c;

    dutya = PRD_div2 + 2/sqrt(3)*vsa_svpwm*PRD_div2;
    dutyb = PRD_div2 + 2/sqrt(3)*vsb_svpwm*PRD_div2;
    dutyc = PRD_div2 + 2/sqrt(3)*vsc_svpwm*PRD_div2;

  }// Fecha o control_enable

} // fecha a interrupção

///////////////////////////////PWM//////////////////////////////////////////////
if(control_enable == 1)
{
  if(dutya>=count)
  {
    S1 = 1;
    S2 = 0;
  }
  else
  {
    S1 = 0;
    S2 = 1;
  }

  if(dutyb>=count)
  {
    S3 = 1;
    S4 = 0;
  }
  else
  {
    S3 = 0;
    S4 = 1;
  }

  if(dutyc>=count)
  {
    S5 = 1;
    S6 = 0;
  }
  else
  {
    S5 = 0;
    S6 = 1;
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

Output(0) = S1;
Output(1) = S2;
Output(2) = S3;
Output(3) = S4;
Output(4) = S5;
Output(5) = S6;
Output(6) = PRf_alfa.Xm;
Output(7) = PRf_alfa.Xref;
Output(8) = PRf_beta.Xm;
Output(9) = PRf_beta.Xref;
Output(10) = Vdc_ref;
Output(11) = fil2nVdc.y;
Output(12) = PIq.Xref;
Output(13) = PIq.Xm;
Output(14) = Vpwm_norm_a;
Output(15) = Vpwm_norm_b;
Output(16) = Vpwm_norm_c;
Output(17) = count;
Output(18) = Vdq.q;
Output(19) = Vdq.d;