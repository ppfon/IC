clear all;

syms t 

%%%%% DADOS BASICOS SOBRE O SINAL %%%%%

omega = 377; % freq. angular
freq = omega/(2*pi); % freq.
periodo = 1/freq; % periodo
theta_carac = 2*pi/3; % angulo caracteristico do sistema
defasagem = deg2rad(30);
p = omega*t;

i_abc_pico = 10; 
dc_offset = 0; % offset 

% tensoes do sistema
v_abc_pico = 180; % p.u; sinal de teste
v_a_fasor = cos(omega*t);                   % fase A
v_b_fasor = cos(omega*t - theta_carac);     % fase B
v_c_fasor = cos(omega*t - 2*theta_carac);   % fase C
v_abc_vetor = v_abc_pico * [v_a_fasor; v_b_fasor; v_c_fasor];

% correntes do sistema
i_a_fasor = cos(omega*t - 0*theta_carac + defasagem) + dc_offset; % fase A
i_b_fasor = cos(omega*t - 1*theta_carac + defasagem) + dc_offset; % fase B
i_c_fasor = cos(omega*t - 2*theta_carac + defasagem) + dc_offset; % fase C
i_abc_vetor = i_abc_pico * [i_a_fasor; i_b_fasor; i_c_fasor];

%%%%% TRANSFORMACOES %%%%%

%%%%% CLARKE %%%%%
norma = 2/3; % normalizaçao da transformação invariante em amplitude
matriz_clarke = [    1/2        1/2         1/2;
                     1          -1/2        -1/2;
                     0          sqrt(3)/2   -sqrt(3)/2;
                     ];
                  

%matriz_clarke_inv = inv(matriz_clarke);

v_clarke_vetor = norma\matriz_clarke * v_abc_vetor;
i_clarke_vetor = norma\matriz_clarke * i_abc_vetor;

%%%%% 0DQ %%%%%
matriz_0dq = [       1/2        1/2                      1/2;
                    cos(p)     cos(p - 1*theta_carac)   cos(p - 2*theta_carac);
                    -sin(p)    -sin(p - 1*theta_carac)  -sin(p - 2*theta_carac);
                    ];
v_0dq_vetor = norma\matriz_0dq * v_abc_vetor;
i_0dq_vetor = norma\matriz_0dq * i_abc_vetor;

%%%%% CALCULO DE POTENCIA %%%%%

s_abc = (3/2) * v_abc_vetor' * conj(i_abc_vetor);

pot_abc = v_abc_vetor' * i_abc_vetor; % pot. nas coordenadas naturais

p_clarke = v_clarke_vetor(2,1) * i_clarke_vetor(2,1) + v_clarke_vetor(3,1) * i_clarke_vetor(3,1);
q_clarke = v_clarke_vetor(3,1) * i_clarke_vetor(2,1) - v_clarke_vetor(2,1) * i_clarke_vetor(3,1);

pot_clarke = 1/norma * (p_clarke + 1*j*q_clarke);

p_0dq = v_0dq_vetor(2,1) * i_0dq_vetor(2,1) + v_0dq_vetor(3,1) * i_0dq_vetor(3,1) ...
        + 2 * (v_0dq_vetor(1,1) * i_0dq_vetor(1,1));

q_0dq = v_0dq_vetor(3,1) * i_0dq_vetor(2,1) - v_0dq_vetor(2,1) * i_0dq_vetor(3,1);

pot_0dq =  1/norma * (p_0dq + 1*j*q_0dq);

%%%%% PLOT DOS GRAFICOS %%%%%
figure(1);

subplot(3,1,1);

fplot(pot_abc, [0 2*periodo]);

legend('p_{abc}', 'q_{abc}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'s_{a,b,c} [VA]'});
title({'Potência aparente no referencial abc'});

subplot(3,1,2);

fplot(pot_clarke, [0 2*periodo]);
legend('p_{0, \alpha, \beta}', 'q_{0, \alpha, \beta}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'s 0, \alpha, \beta [VA]'});
title({'Potência aparente no referencial 0, \alpha, \beta'});

subplot(3,1,3);
fplot(pot_0dq, [0 2*periodo]);
legend('p_{0, d, q}', 'q_{0, d, q}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'s_{0, d, q} [VA]'});
title({'Potência aparente no referencial 0, d, q'});
