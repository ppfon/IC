% Controle ressonante
Rg = 3;
Rf = 3;
L = 1e-3;

R = Rf + Rg;
Kin = 1000;%-2*pi*fc_ab*R*2;
T=1/fsw;

ro = exp(R*T/L);
kp1 = R*sqrt(2+2*ro^-2-(1+sqrt(5))*ro^-1)/((1-ro^-1)*sqrt(2));

kr;