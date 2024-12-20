set(gca, 'YAxisLocation', 'origin')

% Frequência de amostragem
freq_amostragem = 9e3; % 9 kHz
periodo_amostragem = 1/freq_amostragem;

% Carregar os dados
le_ia = load("Novos Dados\bpsc\0.3333\correntes\ia.mat", "base");
ia = le_ia.base;
le_ib = load("Novos Dados\bpsc\0.3333\correntes\ib.mat", "base");
ib = le_ib.base;

amplitude_ia = ia(:,2);
amplitude_ib = ib(:,2);

% Corrigir a diferença de tamanho entre os sinais
length_ia = length(amplitude_ia);
length_ib = length(amplitude_ib);

if length_ia > length_ib
    % Zerando o excesso de amostras de ia para igualar os tamanhos
    amplitude_ia = amplitude_ia(1:length_ib); % Cortar o excesso de amostras de ia
else
    % Zerando o excesso de amostras de ib para igualar os tamanhos
    amplitude_ib = amplitude_ib(1:length_ia); % Cortar o excesso de amostras de ib
end

% Criar os vetores de tempo
tempo_ia = (0:length(amplitude_ia)-1)/freq_amostragem;
tempo_ib = (0:length(amplitude_ib)-1)/freq_amostragem;

% Defasagem atual observada (84 graus)
defasagem_angular_atual = 84; 

% Defasagem desejada de 120 graus
defasagem_angular_desejada = 120; 

% Diferença de defasagem a corrigir (em graus)
diferenca_defasagem = defasagem_angular_desejada - defasagem_angular_atual; 

% Converter a diferença de graus para número de amostras
amostras_por_grau = (1/60) * freq_amostragem / 360; % Amostras por grau para uma onda de 60 Hz
ajuste_defasagem_amostras = round(diferenca_defasagem * amostras_por_grau); % Diferença em amostras

% Verificando qual sinal está adiantado e corrigindo
[~, pico_ia] = max(amplitude_ia);
[~, pico_ib] = max(amplitude_ib);

if pico_ia < pico_ib
    amplitude_ib = circshift(amplitude_ib, ajuste_defasagem_amostras); % Adiantar ib
else
    amplitude_ia = circshift(amplitude_ia, ajuste_defasagem_amostras); % Adiantar ia
end

% Calcular a corrente Ic como -(Ia + Ib)
amplitude_ic = -(amplitude_ia + amplitude_ib); % Agora as duas têm o mesmo tamanho

% Plotar os resultados
figure(1);

plot(tempo_ia, amplitude_ia, 'r', 'DisplayName', 'Ia');
titulo = 'Correntes na estrategia BPSC com $P_{\mathrm{ref}} = 1 \; \mathrm{kVA} = Q_{\mathrm{ref}}$';
title(titulo, 'interpreter', 'latex');

grid on;
hold on;
plot(tempo_ib, amplitude_ib, 'b', 'DisplayName', 'Ib');
plot(tempo_ia, amplitude_ic, 'k', 'DisplayName', 'Ic'); % Ic usando o mesmo vetor de tempo de Ia
xlim([4.6 4.65]); ylim([-10 10]);
xlabel('Tempo [s]'); ylabel('Corrente [A]')
legend;
hold off;
