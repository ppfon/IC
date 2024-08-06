clear; close all; clc;

s = tf('s');
Cdc = 3*(4.7e-3);
fc = 0.5;
wc = 2*pi*fc;
MF = 60;
%C�digo

Tplanta = (2/(Cdc*s))
%%Tplanta = (2/(Cdc*s));

[Amp,PH] = bode(Tplanta,wc);
Gain_PI = 1/Amp;
Phase_PI = -PH - 180 + MF;
Tan_PI = (1/wc)*tan(pi*(Phase_PI + 90)/180);
Kpi = (Gain_PI*wc)/(sqrt(1+(wc*Tan_PI)^2));
KP = Kpi*Tan_PI
KI = Kpi

Gc = KP+KI/s;
MA = Tplanta*Gc;


kapa = tan(pi*(-PH-90+MF)/180)/wc;
Kp2 = wc*kapa/(Amp*sqrt(1+(wc*kapa)^2));
Ki2 = wc/(Amp*sqrt(1+(wc*kapa)^2));
Gc2 = Kp2+Ki2/s;
MA2 = Tplanta*Gc2;

bode(MA)
hold
bode(MA2)
grid