clear
clc
close all

%% Coeficientes do filtro de Primeira ordem

% Frequencia de amostragem:
fsample = 9000;
Ts = 1/fsample;
format long

fso = 2.5;  % frequência do filtro [Hz]

Cf0 = Ts/(1/(2*pi*fso));
Cf1 = Ts/(1/(2*pi*fso));

fprintf('Coeficientes do Filtro de Primeira Ordem:\n\n')
display(num2str(Cf0,'Cf0 = %.20f'));
display(num2str(Cf1,'Cf1 = %.20f'));


% 
% %% Coeficientes controlador ressonante
% clc;
% clear;
% Ts = 1/(9000);
% wn = 2*pi*60;
% h = 1;
% 
% s = tf('s');
% Gc =  s/(s^2+(h*wn)^2);
% opt = c2dOptions('Method','tustin','PrewarpFrequency',h*wn);
% Gcz = c2d(Gc,Ts,opt);
% [num,den,Tsm] = tfdata(Gcz);
% 
% c1 = num{1}(1)/den{1}(1);
% c2 = num{1}(3)/den{1}(1);
% c3 = den{1}(2)/den{1}(1);
% c4 = den{1}(3)/den{1}(1);
% 
% display(num2str(c1,'c1 = %.20f'));
% display(num2str(c2,'c2 = %.20f'));
% display(num2str(c3,'c3 = %.20f'));
% display(num2str(c4,'c4 = %.20f'));
% 
% %% Parametros Filtro
% fsw = 9000;
% fn = 60;
% Lf = 1e-3;
% Cf = 25e-06;
% %Rd = 1.5;
% Lg = Lf;
% L = Lg+Lf;
% Rf = 2*pi*fn*Lf/18.8982;
% Rg = 2*pi*fn*Lg/18.8982;
% Rd = 1.8;
% R = Rg+Rf;
% 
% % Controle ressonante
% Kin = 1000;%-2*pi*fc_ab*R*2;
% T=1/fsw;
% ro=exp(R*T/L);
% Kp_eq_13 = R*sqrt(2+2*ro^-2-(1+sqrt(5))*ro^-1)/((1-ro^-1)*sqrt(2))
% 
% %% Projeto filtro passa baixa segunda ordem
% clc
% clear
% s = tf('s');
% zeta = 0.707;
% wn = 2*pi*60;
% Ts = 1/9000;
% z = tf('z',Ts);
% 
% format long
% Hd = wn^2 / (s^2 + 2*zeta*wn*s + wn^2);
% 
% Hdz = c2d(Hd,Ts,'tustin');
% 
% step(Hd);
% 
% [num,den,Tsm] = tfdata(Hdz);
% 
% % y = x*c0 + x*c1*z^-1 + x*c2*z^-2 - y*c3*z^-1 - y*c4*z^-2
% 
% c0 = num{1}(1)/den{1}(1);
% c1 = num{1}(2)/den{1}(1);
% c2 = num{1}(3)/den{1}(1);
% c3 = den{1}(2)/den{1}(1);
% c4 = den{1}(3)/den{1}(1);
% 
% display(num2str(c0,'c0 = %.20f'));
% display(num2str(c1,'c1 = %.20f'));
% display(num2str(c2,'c2 = %.20f'));
% display(num2str(c3,'c3 = %.20f'));
% display(num2str(c4,'c4 = %.20f'));
% 
% %% Projeto ganho controle do Vdc quadrado
% clear; close all; clc;
% 
% s = tf('s');
% Cdc = 3*(4.7e-3);
% fc = 10;
% wc = 2*pi*fc;
% MF = 60;
% %Código
% 
% Tplanta = (2/(Cdc*s))
% %%Tplanta = (2/(Cdc*s));
% 
% [Amp,PH] = bode(Tplanta,wc);
% Gain_PI = 1/Amp;
% Phase_PI = -PH - 180 + MF;
% Tan_PI = (1/wc)*tan(pi*(Phase_PI + 90)/180);
% Kpi = (Gain_PI*wc)/(sqrt(1+(wc*Tan_PI)^2));
% KP = Kpi*Tan_PI
% KI = Kpi
% 
% Gc = KP+KI/s;
% MA = Tplanta*Gc;
% 
% 
% kapa = tan(pi*(-PH-90+MF)/180)/wc;
% Kp2 = wc*kapa/(Amp*sqrt(1+(wc*kapa)^2));
% Ki2 = wc/(Amp*sqrt(1+(wc*kapa)^2));
% Gc2 = Kp2+Ki2/s;
% MA2 = Tplanta*Gc2;
% 
% bode(MA)
% hold
% bode(MA2)
% grid
% 
% %% Projeto ganho malha de reativo
% clear; close all; clc;
% 
% s = tf('s');
% fc = 2;
% wc = 2*pi*fc;
% 
% Ki = wc
% 
% %% Projeto ganho controle de corrente do conversor Dc/Dc 
% clear;
% clc;
% close all;
% 
% fsw = 9000;
% fc = fsw/20;
% Vdc = 500;
% R = 0.55;
% L = 4e-3;
% Nbseries = 16;
% Nbstrins = 1;
% Rint = 7.1e-3 * Nbseries/Nbstrins;
% 
% K = Vdc/(R+Rint);
% Tm = L/(R+Rint);
% 
% KP = 2*pi*fc*Tm/K;
% KI = 2*pi*fc/K;
% 
% % s = tf('s');
% % PI = KP + KI/s;
% % F = K/(1+Tm*s);
% % MA = PI*F;
% % bode(MA)
% % grid
% 
% 
% disp('____________________________________________________');
% disp('-------------Ganhos do Controle de Corrente do Boost----------------');
% disp('____________________________________________________');
% disp({'KP =',num2str(KP)});
% disp({'KI =',num2str(KI)});
% 
% disp('____________________________________________________');
% disp('-------------Ganhos do Controle de Corrente do Buck----------------');
% disp('____________________________________________________');
% disp({'KP =',num2str(KP)});
% disp({'KI =',num2str(KI)});
% 
% 
% %COntrole da tensão nas baterias
% Ke = Rint;
% fc2 = 0.5;            %%freq do polo
% fc1 = fc2*20;         %%freq do zero
% 
% KP = 2*pi*fc2/(2*pi*Ke*(fc1-fc2));
% KI = 2*pi*fc1*KP;
% 
% s = tf('s');
% PI = KP + KI/s;
% MA = PI*Ke;
% bode(MA)
% grid
% 
% disp('____________________________________________________');
% disp('-------------Ganhos do Controle de Tensão do Buck----------------');
% disp('____________________________________________________');
% disp({'KP =',num2str(KP)});
% disp({'KI =',num2str(KI)});
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %% Bode Ressonante
% clc;
% clear;
% close all;
% 
% s = tf('s');
% fn = 60;
% wn = 2*pi*60;
% 
% Lf = 1e-3;
% Rf  = 2*pi*fn*Lf/18.8982;
% Lg = Lf;
% Rg = Rf;
% 
% Kp = 10;
% Ki = 1000;
% 
% Lt = Lf + Lg;
% Rt = Rf + Rg;
% 
% PL = 1/(Lt*s+Rt);
% s = tf('s');
% Gc = ss(Kp + Ki*s/(s^2+(wn)^2) + Ki*s/(s^2+(5*wn)^2) + Ki*s/(s^2+(7*wn)^2));
% 
% MA = ss(PL*Gc);
% 
% bode(MA)
% grid
% 
% 
