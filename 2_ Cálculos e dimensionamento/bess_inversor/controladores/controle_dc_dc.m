%%% Projeto ganho controle de corrente do conversor Dc/Dc 
clear; clc; close all;
%%% Parâmetros
fsw = 9000;
fc = fsw/20;
Vdc = 500;
Rin = 0.55;
L = 4e-3;

Nbseries = 16;
Nbstrins = 1;
Rbat = 7.1e-3 * Nbseries/Nbstrins;
N = 3;

%%% Cálculo do ganho dos controladores
num_p = Vdc;
deno_p = [L, Rin + N*Rbat];
G = tf(num_p, deno_p);

% Ganhos no DSP para N = 3: 
% kp3 = 0.0050265; ki3 = 0.8339;
tau_d = 1/(2*pi*fc);
kp3 = L/(Vdc * tau_d);
ki3 = (Rin + N*Rbat)/(Vdc * tau_d);

num_c = [kp3 ki3];
deno_c = [1 0];
sys = tf(num_c, deno_c);
C = tf(num_c, deno_c);

H = 1;

% controlSystemDesigner(G, 1, H);
% controlSystemDesigner(G, C, H);
figure(1);
grid on;
subplot(2,3,1);
rlocus(G); title('L(s) = G(s)');
subplot(2,3,4);
rlocus(G*C); title('L(s) = G(s) * C(s)');

subplot(2,3,2);
nyquist(G); title('L(s) = G(s)');
subplot(2,3,5);
nyquist(G*C); title('L(s) = G(s) * C(s)');

subplot(2,3,3);
bode(G); title('L(s) = G(s)');
subplot(2,3,6);
bode(G*C); title('L(s) = G(s) * C(s)'); 

disp('Ganhos do Controle de Corrente em Buck e Boost');
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