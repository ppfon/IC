set(gca, 'YAxisLocation', 'origin')

% Frequência de amostragem
freq_amostragem = 9e3; % 9 kHz
periodo_amostragem = 1/freq_amostragem;

% Carregar os dados
le_ia = readmatrix("Novos Dados\bpsc\0.5714\q1000p1000\ia.csv");
%ia = le_ia.base;
le_ib = readmatrix("Novos Dados\bpsc\0.5714\q1000p1000\ib.csv");
%ib = le_ib.base;

amplitude_ia = le_ia(:,2); tempo_ia = (le_ia(:,1)-le_ia(1,1));%/freq_amostragem;
amplitude_ib = le_ib(:,2); tempo_ib = (le_ib(:,1)-le_ib(1,1));%/freq_amostragem;

base_inf = 20000; base_sup = 80000;
amplitude_ia = le_ia((le_ia(:, 1) >= base_inf) & (le_ia(:, 1) <= base_sup), :);
amplitude_ib = le_ib((le_ia(:, 1) >= base_inf) & (le_ib(:, 1) <= base_sup), :);

% Criar os vetores de tempo
% tempo_ia = (0:length(amplitude_ia)-1)/freq_amostragem;
% tempo_ib = (0:length(amplitude_ib)-1)/freq_amostragem;

figure(1);

plot(tempo_ia, amplitude_ia, 'r', 'DisplayName', 'Ia');
titulo = 'Correntes na estrategia BPSC com $P_{\mathrm{ref}} = 1 \; \mathrm{kVA} = Q_{\mathrm{ref}}$';
title(titulo, 'interpreter', 'latex');

grid on;
hold on;
plot(tempo_ib, amplitude_ib, 'b', 'DisplayName', 'Ib');
plot(tempo_ia, amplitude_ia, 'k', 'DisplayName', 'Ia'); % Ic usando o mesmo vetor de tempo de Ia
%xlim([4.6 4.65]); ylim([-10 10]);
xlabel('Tempo [s]'); ylabel('Corrente [A]')
legend;
hold off;
