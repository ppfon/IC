clear all;

syms t 

%%%%% DADOS BASICOS SOBRE O SINAL %%%%%

omega = 377; % freq. angular
freq = omega/(2*pi); % freq.
periodo = 1/freq; % periodo
theta_carac = 2*pi/3; % angulo caracteristico do sistema

i_a_pico = 1; % 1 pu ou 1 ampere (i_base = 1A)
i_b_pico = 1; i_c_pico = 1;
dc_offset = i_a_pico/2; % offset 

% correntes do sistema
i_a_fasor = i_a_pico * cos(omega*t - 0*theta_carac) + dc_offset; % fase A
i_b_fasor = i_b_pico * cos(omega*t - 1*theta_carac) + dc_offset; % fase B
i_c_fasor = i_c_pico * cos(omega*t - 2*theta_carac) + dc_offset; % fase C
i_abc_vetor = [i_a_fasor; i_b_fasor; i_c_fasor];

%%%%% TRANSFORMACOES %%%%%
% Transformaçao invariante em potencia
norm_pot = sqrt(2/3); % normalizacao

matriz_transf_pot = [1/sqrt(2) 1/sqrt(2)  1/sqrt(2);
                     1         -1/2       -1/2;
                     0         sqrt(3)/2  -sqrt(3)/2;
                     ];

matriz_transf_pot_inv = matriz_transf_pot';

i_transf_pot_vetor = norm_pot * matriz_transf_pot * i_abc_vetor;


% Transformacao invariante em amplitude
norm_amp = 2/3; % normalizaçao 
matriz_transf_amp = [1/2        1/2      1/2;
                     1         -1/2      -1/2;
                     0        sqrt(3)/2  -sqrt(3)/2;
                     ];
                  

matriz_transf_amp_inv = inv(matriz_transf_amp);

i_transf_amp_vetor = norm_amp * matriz_transf_amp * i_abc_vetor;



%%%%% TRANSFORMACOES INVERSAS %%%%%

% Transformacao inversa invariante em potencia
i_transf_pot_vetor_inv = norm_pot\matriz_transf_pot_inv * i_transf_pot_vetor;

% Transformacao inversa invariante em amplitude
i_transf_amp_vetor_inv = norm_amp\matriz_transf_amp_inv * i_transf_amp_vetor;

%%%%% VERIFICAÇAO VIA CALCULO DE POTENCIA %%%%%
% v_abc_pico = 1 p.u; sinal de teste
v_a_fasor = cos(omega*t); v_b_fasor = cos(omega*t - theta_carac); v_c_fasor = cos(omega*t - 2*theta_carac);
v_abc_vetor = [v_a_fasor; v_b_fasor; v_c_fasor];

pot_abc = v_abc_vetor' * i_abc_vetor; % pot. nas coordenadas naturais

v_transf_pot_vetor = norm_pot * matriz_transf_pot * v_abc_vetor;
pot_transf_inv = v_transf_pot_vetor' * i_transf_pot_vetor; % pot. na transf. INVARIANTE em pot.

v_transf_amp_vetor = norm_amp * matriz_transf_amp * v_abc_vetor;
pot_transf_var = v_transf_amp_vetor' * i_transf_amp_vetor;  % pot. na transf. VARIANTE em pot.

%%%%% PLOT DOS GRAFICOS %%%%%
tarefa_2_2_plot;