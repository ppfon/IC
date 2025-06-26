fsw = 9e3;
fc = fsw/20;
Vdc = 500;
R = 0.15;
L = 1e-3;
Nbseries = 16;
Nbstrins = 1;
Rint = 7.1e-3 * Nbseries/Nbstrins;
n = 6;

K = Vdc/(R+n*Rint);
Tm = L/(R+n*Rint);

KP = 2*pi*fc*Tm/K;
KI = 2*pi*fc/K;

s = tf('s');
PI = KP + KI/s;
F = K/(1+Tm*s);
MA = PI*F;
bode(MA)
grid


disp('____________________________________________________');
disp('-------------Ganhos do Controle de Corrente do Boost----------------');
disp('____________________________________________________');
disp({'KP =',num2str(KP)});
disp({'KI =',num2str(KI)});