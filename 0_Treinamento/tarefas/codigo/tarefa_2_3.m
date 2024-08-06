clear global;

syms t theta p;

%%%%% DADOS BASICOS SOBRE O SINAL %%%%%

omega = 377; % freq. angular
periodo = (2*pi)/omega; % periodo
theta_carac = 2*pi/3; % angulo caracteristico do sistema

p_a = 0*omega*t;  theta_a = 0;  
p_b = 1*omega*t;  theta_b = 0;
p_c = 1*omega*t;  theta_c = deg2rad(50);
p_d = -1*omega*t; theta_d = deg2rad(0);

i_a_pico = 1; % 1 pu ou 1 ampere (i_base = 1A)
i_b_pico = 1;
i_c_pico = 1;
dc_offset = i_a_pico/2; % offset 

% correntes do sistema
i_a_fasor = i_a_pico * cos(omega*t - 0*theta_carac + theta) + dc_offset; % fase A
i_b_fasor = i_b_pico * cos(omega*t - 1*theta_carac + theta) + dc_offset; % fase B
i_c_fasor = i_c_pico * cos(omega*t - 2*theta_carac + theta) + dc_offset; % fase C
i_abc_vetor = [i_a_fasor; i_b_fasor; i_c_fasor];


%%%%% TRANSFORMACOES %%%%%
% Transformacao invariante em amplitude
norm_amp = 2/3; % normalizaçao 
matriz_transf_amp = [1/2        1/2                      1/2;
                     cos(p)     cos(p - 1*theta_carac)   cos(p - 2*theta_carac);
                     -sin(p)    -sin(p - 1*theta_carac)  -sin(p - 2*theta_carac);
                    ];


%%%%% i_sistema-de-coordenadas_alternativa-da-questao %%%%%
i_abc_a = subs(i_abc_vetor, [p, theta], [p_a, theta_a]);
i_0dq_a = subs((norm_amp * matriz_transf_amp * i_abc_vetor), [p, theta], [p_a, theta_a]);

i_abc_b = subs(i_abc_vetor, [p, theta], [p_b, theta_b]);
i_0dq_b = subs((norm_amp * matriz_transf_amp * i_abc_vetor), [p, theta], [p_b, theta_b]);

i_abc_c = subs(i_abc_vetor, [p, theta], [p_c, theta_c]);
i_0dq_c = subs((norm_amp * matriz_transf_amp * i_abc_vetor), [p, theta], [p_c, theta_c]);

i_abc_d = subs(i_abc_vetor, [p, theta], [p_d, theta_d]);
i_0dq_d = subs((norm_amp * matriz_transf_amp * i_abc_vetor), [p, theta], [p_d, theta_d]);


tarefa_2_3_plot;