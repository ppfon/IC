clear global;

syms t

%%%%% DADOS BASICOS SOBRE O SINAL %%%%%

omega = 377; % freq. angular
periodo = (2*pi)/omega; % periodo
theta_carac = 2*pi/3; % angulo caracteristico do sistema
theta_i = deg2rad(30);
theta_v = deg2rad(0);
p = omega;

% corrente de pico em ampere
i_a_pico = 10; i_b_pico = 10; i_c_pico = 10;

% tensao de pico em volts
v_a_pico = 180; v_b_pico = 180; v_c_pico = 180;

% correntes do sistema
i_a_fasor = i_a_pico * cos(omega*t - 0*theta_carac + theta_i); % fase A
i_b_fasor = i_b_pico * cos(omega*t - 1*theta_carac + theta_i); % fase B
i_c_fasor = i_c_pico * cos(omega*t - 2*theta_carac + theta_i); % fase C
i_abc_vetor = [i_a_fasor; i_b_fasor; i_c_fasor];

v_a_fasor = v_a_pico * cos(omega*t - 0*theta_carac + theta_v); % fase A
v_b_fasor = v_b_pico * cos(omega*t - 1*theta_carac + theta_v); % fase B
v_c_fasor = v_c_pico * cos(omega*t - 2*theta_carac + theta_v); % fase C
v_abc_vetor = [v_a_fasor; v_b_fasor; v_c_fasor];

%%%%% TRANSFORMACOES INVARIANTES EM AMPLITUDE %%%%%
norm = 2/3; % normalizacao

matriz_transf_clark = [ 1/2     1/2         1/2;
                        1       -1/2        -1/2;
                        0       sqrt(3)/2   -sqrt(3)/2;
                      ];

% matriz_transf_0dq =  [1/2        1/2                      1/2;
%                      cos(p)     cos(p - 1*theta_carac)   cos(p - 2*theta_carac);
%                      -sin(p)    -sin(p - 1*theta_carac)  -sin(p - 2*theta_carac);
%                     ];
matriz_transf_park = [  1       0           0;
                        0       cos(p)      sin(p);
                        0       -sin(p)     cos(p);
                      ];


matriz_transf_0dq = matriz_transf_clark * matriz_transf_park;
i_clark = norm * matriz_transf_clark * i_abc_vetor;
v_clark = norm * matriz_transf_clark * v_abc_vetor;

i_0dq = norm * matriz_transf_0dq * i_abc_vetor;
v_0dq = norm * matriz_transf_0dq * v_abc_vetor;

pot_abc = v_abc_vetor' * i_abc_vetor;
pot_rea_abc = 3/2 *v_a_pico*i_a_pico * sin(theta_v-theta_i);


p_clark = 1/norm * (v_clark(2,1) * i_clark(2,1) + v_clark(3,1) * i_clark(3,1));
q_clark = 1/norm * (v_clark(3,1) * i_clark(2,1) - v_clark(2,1) * i_clark(3,1));

p_0dq = 1/norm * (v_0dq(2,1) * i_0dq(2,1) + v_0dq(3,1) * i_0dq(3,1));
q_0dq = 1/norm * (v_0dq(3,1) * i_0dq(2,1) - v_0dq(2,1) * i_0dq(3,1));

figure(1);

subplot(3,1,1);
fplot([pot_abc, pot_rea_abc], [0 2*periodo]);
legend('p_{t}', 'q_{t}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'s_{a,b,c}'}); 
ylim([-2000, 4000])
title({'Potencia calculada no referencial abc'});

subplot(3,1,2);
fplot([p_clark, q_clark], [0 2*periodo]);
legend('p_{t}', 'q_{t}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'s_{0,\alpha,\beta}'});
ylim([-2000, 4000])
title({'Potencia calculada no referencial \alpha \beta'});

subplot(3,1,3);
fplot([p_0dq, q_0dq], [0 2*periodo]);
legend('p_{t}', 'q_{t}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'s_{0,d,q}'});
ylim([-2000, 4000])
title({'Potencia calculada no referencial 0dq'});