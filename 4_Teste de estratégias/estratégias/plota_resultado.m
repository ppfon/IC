freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;
resultado_pu = 0;

le_base_ativo = load("Novos dados\apoc\ativa\base.mat", "base");
base_ativo = le_base_ativo.base;

le_stgy_ativo = load("Novos dados\apoc\ativa\stgy.mat", "stgy");
stgy_ativo = le_stgy_ativo.stgy;

amplitude_stgy_ativo = stgy_ativo(:,2);
amplitude_base_ativo = base_ativo(:,2);

le_base_reativo = load("Novos dados\apoc\reativa\base.mat", "base");
base_reativo = le_base_reativo.base;

le_stgy_reativo = load("Novos dados\apoc\reativa\stgy.mat", "stgy");
stgy_reativo = le_stgy_reativo.stgy;

amplitude_stgy_reativo = stgy_reativo(:,2);
amplitude_base_reativo = base_reativo(:,2);

figure(1);

subplot(1,2,1);
[amp, fase, freq] = calcula_espectro(amplitude_base_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title("Potência ativa");
xlabel('Frequência [Hz]'); ylabel('Amplitude [W]');xlim([0 600]);
grid on; 
hold on;
%subplot(2,2,2);
[amp, fase, freq] = calcula_espectro(amplitude_stgy_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'b'); 
%title("Potência ativo - com a estratégia");
%xlabel('Frequência [Hz]'); ylabel('Amplitude [W]');
%grid on;
legend('APOC | P_{ref} = 2kW | Sem estratégia', 'APOC | P_{ref} = 2kW | Com estratégia')
hold off;

subplot(1,2,2)
[amp, fase, freq] = calcula_espectro(amplitude_base_reativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title("Potência reativa");
xlabel('Frequência [Hz]'); ylabel('Amplitude [VAr]'); xlim([0 600]);
grid on; hold on;

%subplot(2,2,4);
[amp, fase, freq] = calcula_espectro(amplitude_stgy_reativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'b'); 
% title("Potência Reativo - com a estratégia");
% xlabel('Frequência [Hz]'); ylabel('Amplitude [VAr]');
% grid on;
legend('APOC | Q_{ref} = 1kVAr | Sem estratégia', 'APOC | Q_{ref} = 1kVAr | Com estratégia')
hold off;


figure(2);
tempo_base_ativo = (0:length(amplitude_base_ativo)-1)/freq_amostragem;
tempo_stgy_ativo = (0:length(amplitude_stgy_ativo)-1)/freq_amostragem;

tempo_base_reativo = (0:length(amplitude_base_reativo)-1)/freq_amostragem;
tempo_stgy_reativo = (0:length(amplitude_stgy_reativo)-1)/freq_amostragem;

subplot(1,2,1);
plot(tempo_base_ativo, amplitude_base_ativo, 'r');
title("Potência ativa");
xlabel('Tempo [s]'); ylabel('Amplitude [W]');
grid on; hold on; xlim([0 0.025]); 


% subplot(2,2,2);
plot(tempo_stgy_ativo, amplitude_stgy_ativo, 'b'); 
% title("Potência ativo - com a estratégia");
% xlabel('Tempo [s]'); ylabel('Amplitude [W]');
% grid on;
legend('APOC | P_{ref} = 2kW | Sem estratégia', 'APOC | P_{ref} = 2kW | Com estratégia');

hold off;

subplot(1,2,2)
plot(tempo_base_reativo, amplitude_base_reativo, 'r');
title("Potência reativa");
xlabel('Tempo [s]'); ylabel('Amplitude [VAr]');
grid on; hold on; xlim([0 0.025]);
% 
% subplot(2,2,4);
plot(tempo_stgy_reativo, amplitude_stgy_reativo, 'b'); 
% title("Potência Reativo - com a estratégia");
% xlabel('Tempo [s]'); ylabel('Amplitude [VAr]');
legend('APOC | P_{ref} = 2kW | Sem estratégia', 'APOC | P_{ref} = 2kW | Com estratégia');
hold off;