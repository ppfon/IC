clear workspace;
freq_amostragem = 9e3; periodo_amostragem = 1/freq_amostragem;
resultado_pu = 0;

le_base_ativo = load("Novos estranhos_apagar/rpoc/0.3333/q1000p1000/ativo/stgy.mat", "stgy");
base_ativo = le_base_ativo.stgy;

le_stgy_ativo = load("Novos estranhos_apagar/rpoc/0.3333/q1000p1000/ativo/stgy.mat", "stgy");
stgy_ativo = le_stgy_ativo.stgy;

amplitude_stgy_ativo = stgy_ativo(:,2);
amplitude_base_ativo = base_ativo(:,2);

le_base_reativo = load("Novos estranhos_apagar/rpoc/0.3333/q1000p1000/reativo/stgy.mat", "stgy");
base_reativo = le_base_reativo.stgy;

le_stgy_reativo = load("Novos estranhos_apagar/rpoc/0.3333/q1000p1000/reativo/stgy.mat", "stgy");
stgy_reativo = le_stgy_reativo.stgy;

amplitude_stgy_reativo = stgy_reativo(:,2);
amplitude_base_reativo = base_reativo(:,2);

figure(1);

subplot(1,2,1);
[amp, fase, freq] = calcula_espectro(amplitude_base_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title("Potência ativo");
xlabel('Frequência [Hz]'); ylabel('Amplitude [W]'); xlim([0 600]);
grid on;
hold on;
%subplot(2,2,2);
[amp, fase, freq] = calcula_espectro(amplitude_stgy_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'b');
%title("Potência ativo - com a estratégia");
%xlabel('Frequência [Hz]'); ylabel('Amplitude [W]');
%grid on;
legend('PNSC | P_{ref} = 0 kW | Sem estratégia', 'PNSC | P_{ref} = 0 kW | Com estratégia')
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
legend('PNSC | Q_{ref} = 1kVAr | Sem estratégia', 'PNSC | Q_{ref} = 1kVAr | Com estratégia')
hold off;



tempo_base_ativo = (0:length(amplitude_base_ativo)-1)/freq_amostragem;
tempo_stgy_ativo = (0:length(amplitude_stgy_ativo)-1)/freq_amostragem;

tempo_base_reativo = (0:length(amplitude_base_reativo)-1)/freq_amostragem;
tempo_stgy_reativo = (0:length(amplitude_stgy_reativo)-1)/freq_amostragem;

 figure(2);

 plot(tempo_base_ativo, amplitude_base_ativo, 'r');
 titulo1 = 'Potencia ativa - PNSC - $P_{\mathrm{ref}} = 2 \; \mathrm{kW}$';
 title(titulo1, 'Interpreter', 'latex');
 xlabel('Tempo [s]'); ylabel('Amplitude [W]');

 grid on; hold on; % xlim([0 0.075]); ylim([1400 2300]);

 plot(tempo_stgy_ativo, amplitude_stgy_ativo, 'b');
 legend('Sem estratégia', 'Com a estratégia');

 hold off;

 figure(3);
 plot(tempo_base_reativo, amplitude_base_reativo, 'r');
 titulo2 = 'Potencia reativa - PNSC - $Q_{\mathrm{ref}} = 0 \; \mathrm{kVAr}$';
 title(titulo2, 'Interpreter', 'latex');
 xlabel('Tempo [s]'); ylabel('Amplitude [VAr]');
 grid on; hold on;
 plot(tempo_stgy_reativo, amplitude_stgy_reativo, 'b');
 legend('Sem estratégia', 'Com estratégia');
 hold off;
