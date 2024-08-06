% Simulação do controlador
syms s
% Parâmetros físicos
fn = 60;
fsw = 9e3;
w = 2*pi*fn;

Lf = 1e-3;
Lg = 1e-3;
L = Lf + Lg;

Rf = 2*pi*fn*Lf/18.8982;
Rg = 2*pi*fn*Lg/18.8982;
R = Rf + Rg;

% Ganhos do controlador
T=1/fsw;
ro=exp(R*T/L);
kp = R*sqrt(2+2*ro^-2-(1+sqrt(5))*ro^-1)/((1-ro^-1)*sqrt(2));
kr = 0.01;

% FT do controlador
num_c = [kp kr];
deno_c = [1, 0, w^2];
C = tf(num_c, deno_c);

% FT da planta
num_p = 1;
deno_p = [L, R];
G = tf(num_p, deno_p);

% FT do sensor e entrada
H = 1;
% transformada de laplace do cos
num_f = [1, 0];
deno_f = [1, 0, w^2];
F = tf(num_f, deno_f);

%controlSystemDesigner(G, C, H, F);
C_ss = tf2ss(num_c, deno_c);