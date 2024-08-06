% Projetar o barramento de corrente contínua 
% de um inversor de 10 kW que irá se
% conectar a uma rede de 60 Hz com 380 V 
% (tensão fase-fase RMS). 
% Considere um ripple máximo de 3%

%%%%% PARAMETROS %%%%%

% Rede externa

freq_rede = 60; % frequencia da rede 

v_ff_rms = 380; % Tensao fase-fase eficaz da rede
v_rede_err = 0.05; % variaçao  maxima da rede

% Inversor
pot_inv = 10e3; % Potencia ativa [watts/VA]
z_inv_out = 0.08; % impedancia de saida [pu]
z_inv_out_err = 0.05; % variaçao maxima da impedancia de saida
z_inv_out_max = 1 + z_inv_out_err;

% Barramento
v_dc_ripple = 0.03; % variaçao maxima 
v_dc_err = 0.02; % erro maximo em regime estacionario

%%%%% RESULTADOS %%%%%

% Rede externa
omega = 2*pi*freq_rede;
v_fn_rms = v_ff_rms/sqrt(3); % tensao fase-neutro (Y equilibrada)  
v_fn_pico = v_fn_rms*sqrt(2); % tensao de pico fase-neutro (cossenoide "ideal")


% Inversor

i_inv_fn_rms = 1/3 * pot_inv/v_fn_rms;
i_inv_fn_pico = i_inv_fn_rms * sqrt(2);

v_inv_fn_pico_min = (1 + v_rede_err) * (1 + z_inv_out * z_inv_out_max) * v_fn_pico;

% Barramento

v_dc_min = 1 - (v_dc_ripple+v_dc_err);
v_dc = v_inv_fn_pico_min * (sqrt(3)/v_dc_min); 

c_min = 3/4 * (i_inv_fn_pico)/(freq_rede * (1 - v_dc_ripple) * v_dc);

format shortEng;
sdisp = @(x) strtrim(evalc(sprintf('disp(%g)', x)));

fprintf('Capacitancia minima do barramento DC [F]: %s \n', sdisp(c_min));
fprintf("Tensao minima do barramento DC [V] : %s \n", sdisp(v_dc));