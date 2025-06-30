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

num_p = Vdc;
deno_p = [L, Rin + N*Rbat];
G = tf(num_p, deno_p);

%kp3 = 0.0050265; ki3 = 0.8339;
tau_d = 1/(2*pi*fc);
kp3 = L/(Vdc * tau_d);
ki3 = (Rin + N*Rbat)/(Vdc * tau_d);

num_c = [kp3 ki3];
deno_c = [1 0];
sys = tf(num_c, deno_c);
C = tf(num_c, deno_c);

L = G*C;
H = 1;

% controlSystemDesigner(G, 1, H);
% controlSystemDesigner(G, C, H);
figure(1);
grid on;
subplot(2,3,1);
rlocus(G); title('L(s) = G(s)');
subplot(2,3,4);
rlocus(L); title('L(s) = G(s) * C(s)');

subplot(2,3,2);
nyquist(G); title('L(s) = G(s)');
subplot(2,3,5);
nyquist(L); title('L(s) = G(s) * C(s)');

subplot(2,3,3);
bode(G); title('L(s) = G(s)');
subplot(2,3,6);
bode(L); title('L(s) = G(s) * C(s)'); 
