freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;

le_antigo = load("Dados\9k\pnsc\q0p2000\reativo\base.mat", "base");
antigo = le_antigo.base;

le_novo = load("Novos dados\pnsc\q0p2000\reativa\base.mat", "base");
novo = le_novo.base;

tempo_novo = (novo(:,1)-novo(1))*periodo_amostragem;
amplitude_novo = novo(:,2);

tempo_antigo = (antigo(:,1)-antigo(1))*(periodo_amostragem);
amplitude_antigo = antigo(:,2);

figure(1);
subplot(1,2,1);
[amp, fase, freq] = calcula_espectro(amplitude_novo, periodo_amostragem, 1);
plot(freq, amp, 'g'); 
title("Sem compensador de 5º e 7º harmônico");
xlabel('Frequência [Hz]'); ylabel('Amplitude [VA]');
grid on;

subplot(1,2,2);
[amp, fase, freq] = calcula_espectro(amplitude_antigo, periodo_amostragem, 1);
plot(freq, amp, 'r');
title("Com compensador de 5º e 7º harmônico");
xlabel('Frequência [Hz]'); ylabel('Amplitude [VA]');
grid on; 
