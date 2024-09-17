freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;
resultado_pu = 0;

le_base_ativa = load("Novos dados\apoc\ativa\base.mat", "base");
base_ativa = le_base_ativa.base;

le_stgy_ativa = load("Novos dados\apoc\ativa\stgy.mat", "stgy");
stgy_ativa = le_stgy_ativa.stgy;

amplitude_stgy_ativa = stgy_ativa(:,2);
amplitude_base_ativa = base_ativa(:,2);

le_base_reativa = load("Novos dados\apoc\reativa\base.mat", "base");
base_reativa = le_base_reativa.base;

le_stgy_reativa = load("Novos dados\apoc\reativa\stgy.mat", "stgy");
stgy_reativa = le_stgy_reativa.stgy;

amplitude_stgy_reativa = stgy_reativa(:,2);
amplitude_base_reativa = base_reativa(:,2);

figure(1);

subplot(1,2,1);
[amp, fase, freq] = calcula_espectro(amplitude_base_ativa, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title("Potência ativa");
xlabel('Frequência [Hz]'); ylabel('Amplitude [W]');xlim([0 600]);
grid on; 
hold on;
%subplot(2,2,2);
[amp, fase, freq] = calcula_espectro(amplitude_stgy_ativa, periodo_amostragem, resultado_pu);
plot(freq, amp, 'b'); 
%title("Potência ativa - com a estratégia");
%xlabel('Frequência [Hz]'); ylabel('Amplitude [W]');
%grid on;
legend('APOC | P_{ref} = 2kW | Sem estratégia', 'APOC | P_{ref} = 2kW | Com estratégia')
hold off;

subplot(1,2,2)
[amp, fase, freq] = calcula_espectro(amplitude_base_reativa, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title("Potência reativa");
xlabel('Frequência [Hz]'); ylabel('Amplitude [VAr]'); xlim([0 600]);
grid on; hold on;

%subplot(2,2,4);
[amp, fase, freq] = calcula_espectro(amplitude_stgy_reativa, periodo_amostragem, resultado_pu);
plot(freq, amp, 'b'); 
% title("Potência Reativa - com a estratégia");
% xlabel('Frequência [Hz]'); ylabel('Amplitude [VAr]');
% grid on;
legend('APOC | Q_{ref} = 1kVAr | Sem estratégia', 'APOC | Q_{ref} = 1kVAr | Com estratégia')
hold off;


figure(2);
tempo_base_ativa = (0:length(amplitude_base_ativa)-1)/freq_amostragem;
tempo_stgy_ativa = (0:length(amplitude_stgy_ativa)-1)/freq_amostragem;

tempo_base_reativa = (0:length(amplitude_base_reativa)-1)/freq_amostragem;
tempo_stgy_reativa = (0:length(amplitude_stgy_reativa)-1)/freq_amostragem;

subplot(1,2,1);
plot(tempo_base_ativa, amplitude_base_ativa, 'r');
title("Potência ativa");
xlabel('Tempo [s]'); ylabel('Amplitude [W]');
grid on; hold on; xlim([0 0.025]); 


% subplot(2,2,2);
plot(tempo_stgy_ativa, amplitude_stgy_ativa, 'b'); 
% title("Potência ativa - com a estratégia");
% xlabel('Tempo [s]'); ylabel('Amplitude [W]');
% grid on;
legend('APOC | P_{ref} = 2kW | Sem estratégia', 'APOC | P_{ref} = 2kW | Com estratégia');

hold off;

subplot(1,2,2)
plot(tempo_base_reativa, amplitude_base_reativa, 'r');
title("Potência reativa");
xlabel('Tempo [s]'); ylabel('Amplitude [VAr]');
grid on; hold on; xlim([0 0.025]);
% 
% subplot(2,2,4);
plot(tempo_stgy_reativa, amplitude_stgy_reativa, 'b'); 
% title("Potência Reativa - com a estratégia");
% xlabel('Tempo [s]'); ylabel('Amplitude [VAr]');
legend('APOC | Q_{ref} = 1kVAr | Sem estratégia', 'APOC | Q_{ref} = 1kVAr | Com estratégia');
hold off;