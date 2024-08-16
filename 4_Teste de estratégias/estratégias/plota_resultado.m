freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;
resultado_pu = 0;

le_base_ativo = load("Novos dados\bpsc\q2000p0\ativo\base.mat", "stgy");
base_ativo = le_base_ativo.stgy;

le_stgy_ativo = load("Novos dados\bpsc\q2000p0\ativo\stgy.mat", "stgy");
stgy_ativo = le_stgy_ativo.stgy;

amplitude_stgy_ativo = stgy_ativo(:,2);
amplitude_base_ativo = base_ativo(:,2);

le_base_reativo = load("Novos dados\bpsc\q2000p0\reativo\base.mat", "stgy");
base_reativo = le_base_reativo.stgy;

le_stgy_reativo = load("Novos dados\bpsc\q2000p0\reativo\stgy.mat", "stgy");
stgy_reativo = le_stgy_reativo.stgy;

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



figure(2);
tempo_base_ativo = (0:length(amplitude_base_ativo)-1)/freq_amostragem;
tempo_stgy_ativo = (0:length(amplitude_stgy_ativo)-1)/freq_amostragem;

tempo_base_reativo = (0:length(amplitude_base_reativo)-1)/freq_amostragem;
tempo_stgy_reativo = (0:length(amplitude_stgy_reativo)-1)/freq_amostragem;

subplot(2,2,1);
plot(tempo_base_ativo, amplitude_base_ativo, 'r');
title("Ativo - sem estratégia");
xlabel('Tempo [s]'); ylabel('Amplitude [W]');
grid on; 

subplot(2,2,2);
plot(tempo_stgy_ativo, amplitude_stgy_ativo, 'g'); 
title("Ativo - com a estratégia");
xlabel('Tempo [s]'); ylabel('Amplitude [W]');
grid on;

subplot(2,2,3)
plot(tempo_base_reativo, amplitude_base_reativo, 'r');
title("Reativo - sem estratégia");
xlabel('Tempo [s]'); ylabel('Amplitude [VAr]');
grid on; 

subplot(2,2,4);
plot(tempo_stgy_reativo, amplitude_stgy_reativo, 'g'); 
title("Reativo - com a estratégia");
xlabel('Tempo [s]'); ylabel('Amplitude [VAr]');
grid on;