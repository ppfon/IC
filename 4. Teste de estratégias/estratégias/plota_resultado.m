freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;
resultado_pu = 0;

le_base_ativo = load("9k\apoc\ativo\base.mat", "base");
base_ativo = le_base_ativo.base;

le_stgy_ativo = load("9k\apoc\ativo\comeco.mat", "base");
stgy_ativo = le_stgy_ativo.base;

amplitude_stgy_ativo = stgy_ativo(:,2);
amplitude_base_ativo = base_ativo(:,2);

le_base_reativo = load("9k\apoc\reativo\base.mat", "base");
base_reativo = le_base_reativo.base;

le_stgy_reativo = load("9k\apoc\reativo\stgy.mat", "base");
stgy_reativo = le_stgy_reativo.base;

amplitude_stgy_reativo = stgy_reativo(:,2);
amplitude_base_reativo = base_reativo(:,2);

figure(1);

subplot(2,2,1);
[amp, fase, freq] = calcula_espectro(amplitude_base_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title("Ativo - sem estratégia");
xlabel('Frequência [Hz]'); ylabel('Amplitude [W]');
grid on; 

subplot(2,2,2);
[amp, fase, freq] = calcula_espectro(amplitude_stgy_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'g'); 
title("Ativo - com a estratégia");
xlabel('Frequência [Hz]'); ylabel('Amplitude [W]');
grid on;

subplot(2,2,3)
[amp, fase, freq] = calcula_espectro(amplitude_base_reativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title("Reativo - sem estratégia");
xlabel('Frequência [Hz]'); ylabel('Amplitude [VAr]');
grid on; 

subplot(2,2,4);
[amp, fase, freq] = calcula_espectro(amplitude_stgy_reativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'g'); 
title("Reativo - com a estratégia");
xlabel('Frequência [Hz]'); ylabel('Amplitude [VAr]');
grid on;