% Dados de aquisição
fs = 9e3;                % Sampling frequency (Hz)
Ts = 1/fs;
fn = 60;                 % Fundamental frequency (Hz)
tempo = linspace(0, 20/fn, fs);  % Time vector over 20 cycles

% Parâmetros da rede
theta = 0; 
wn = 2*pi*fn;
theta_c = 2*pi/3;

v_ff = 220;
deseq = 0.6;
amp_a = v_ff*sqrt(2)/sqrt(3); 
amp_b = amp_a*deseq;
amp_c = amp_a*deseq;

% Sinais de fase em domínio do tempo (reais)
Va = amp_b * cos(wn * tempo + theta);
Vb = amp_a * cos(wn * tempo + theta - theta_c);
Vc = amp_b * cos(wn * tempo + theta - 2*theta_c);

% Converter os sinais reais em sinais analíticos (complexos)
Va_analytic = hilbert(Va);
Vb_analytic = hilbert(Vb);
Vc_analytic = hilbert(Vc);

% Montar a matriz de sinais de fase (analíticos)
Vabc_analytic = [Va_analytic; Vb_analytic; Vc_analytic];

% Matriz de transformação de Fortescue (Componentes Simétricas)
a = exp(1j*theta_c);
A_transform = 1/3 * [1,    1,    1;
                     1,    a,   a^2;
                     1,   a^2,   a];

% Cálculo das componentes simétricas (no domínio do tempo)
V_seq = A_transform * Vabc_analytic;
V0 = V_seq(1, :);   % Componente zero
V1 = V_seq(2, :);   % Componente positiva
V2 = V_seq(3, :);   % Componente negativa

% Cálculo do fator de desbalanço instantâneo (u) para cada instante
u_t = abs(V2) ./ abs(V1);

% Para obter um valor único representativo, pode-se calcular a média
u_mean = mean(u_t);

% Exibir o fator de desbalanço médio
fprintf('Fator de desbalanço (u) médio: %f\n', u_mean);

% Plot das magnitudes das componentes simétricas ao longo do tempo
figure;
plot(tempo, abs(V0), 'k', 'LineWidth', 1.5); hold on;
plot(tempo, abs(V1), 'b', 'LineWidth', 1.5);
plot(tempo, abs(V2), 'r', 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Magnitude (pu)');
legend('Componente Zero', 'Componente Positiva', 'Componente Negativa');
title('Componentes Simétricas no Domínio do Tempo');
grid on;

% Plot do fator de desbalanço instantâneo
figure;
plot(tempo, u_t, 'm', 'LineWidth', 1.5);
xlabel('Tempo (s)');
ylabel('Fator de Desbalanço (u)');
title('Fator de Desbalanço Instantâneo');
grid on;
