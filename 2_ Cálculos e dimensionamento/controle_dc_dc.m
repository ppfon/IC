%%% Projeto ganho controle de corrente do conversor Dc/Dc 
clear;
clc;
close all;

%%% Parâmetros

fsw = 9000;
fc = fsw/20;
Vdc = 500;
R = 0.55;
L = 4e-3;
Nbseries = 16;
Nbstrins = 1;
Rbat = 7.1e-3 * Nbseries/Nbstrins;

%%% Cálculo dos ganho do controle de corrente (T3 e T4)

K = Vdc/(R+Rbat);
Tm = L/(R+Rbat);

kp3 = 2*pi*fc*Tm/K;
ki3 = 2*pi*fc/K;


disp('____________________________________________________');
disp('-------------Ganhos do Controle de Corrente em Buck e Boost----------------');
disp('____________________________________________________');
disp({'kp3 =',num2str(kp3)});
disp({'ki3 =',num2str(ki3)});

%%% Cálculo dos ganhos do controle de tensão nas baterias
%%% OBS.: Exclusivo das topologias T2 e T3 durante a carga 
%%% (faixa de tensão constante de carregamento)

fc2 = 0.5;            %%freq do polo
fc1 = fc2*20;         %%freq do zero

kp4 = fc2/(Rbat*(fc1-fc2));
ki4 = 2*pi*fc1*kp4;

disp('____________________________________________________');
disp('-------------Ganhos do Controle de Tensão do Buck----------------');
disp('____________________________________________________');
disp({'kp4 =',num2str(kp4)});
disp({'ki4 =',num2str(ki4)});

%s = tf('s');
%PI = kp3 + ki3/s;
%MA = PI*Ke;
%bode(MA)
%grid



