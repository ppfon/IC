%% Projeto ganho controle de corrente do conversor Dc/Dc 
clear;
clc;
close all;

fsw = 9000;
fc = fsw/20;
Vdc = 500;
R = 0.55;
L = 4e-3;
Nbseries = 16;
Nbstrins = 1;
Rint = 7.1e-3 * Nbseries/Nbstrins;

K = Vdc/(R+Rint);
Tm = L/(R+Rint);

KP = 2*pi*fc*Tm/K;
KI = 2*pi*fc/K;

% s = tf('s');
% PI = KP + KI/s;
% F = K/(1+Tm*s);
% MA = PI*F;
% bode(MA)
% grid


disp('____________________________________________________');
disp('-------------Ganhos do Controle de Corrente do Boost----------------');
disp('____________________________________________________');
disp({'KP =',num2str(KP)});
disp({'KI =',num2str(KI)});

disp('____________________________________________________');
disp('-------------Ganhos do Controle de Corrente do Buck----------------');
disp('____________________________________________________');
disp({'KP =',num2str(KP)});
disp({'KI =',num2str(KI)});


%COntrole da tensão nas baterias
Ke = Rint;
fc2 = 0.5;            %%freq do polo
fc1 = fc2*20;         %%freq do zero

KP = 2*pi*fc2/(2*pi*Ke*(fc1-fc2));
KI = 2*pi*fc1*KP;

s = tf('s');
PI = KP + KI/s;
MA = PI*Ke;
bode(MA)
grid

disp('____________________________________________________');
disp('-------------Ganhos do Controle de Tensão do Buck----------------');
disp('____________________________________________________');
disp({'KP =',num2str(KP)});
disp({'KI =',num2str(KI)});


