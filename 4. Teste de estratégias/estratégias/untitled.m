le_stgy = load("pratica\rpoc\reativo\teste.mat", "base");
stgy = le_stgy.base;

le_base = load("pratica\rpoc\reativo\base.mat", "base");
base = le_base.base;

freq_amostragem = 1e3; periodo_amostragem = 1/freq_amostragem; freq_nysq = freq_amostragem/2;

tempo_base = (base(:,1)-base(1))*periodo_amostragem;
amplitude_base = base(:,2);
num_pontos_base = numel(tempo_base);

Y_base = fft(amplitude_base, num_pontos_base);
aux_base = freq_amostragem/num_pontos_base*(0:(num_pontos_base/2));

P2_base = abs(Y_base/num_pontos_base);
P1_base = P2_base(1:num_pontos_base/2+1);
P1_base(2:end-1) = 2*P1_base(2:end-1);

tempo_stgy = (stgy(:,1)-stgy(1))*periodo_amostragem;
amplitude_stgy = stgy(:,2);
num_pontos_stgy = numel(tempo_stgy);

Y_stgy = fft(amplitude_stgy, num_pontos_stgy);
%Y_stgy = fft(hanning(length(amplitude_stgy)).*amplitude_stgy);
aux_stgy = freq_amostragem/num_pontos_stgy*(0:(num_pontos_stgy/2));

P2_stgy = abs(Y_stgy/num_pontos_stgy);
P1_stgy = P2_stgy(1:num_pontos_stgy/2+1);
P1_stgy(2:end-1) = 2*P1_stgy(2:end-1);
periodo_amostragem = 1/(1e3);
freq_amostragem = 1/periodo_amostragem;
t = (0:num_pontos_stgy-1)*periodo_amostragem;
S = 1000 + 120*sin(2*pi*120*t);
Y = fft(S);
aux = freq_amostragem/num_pontos_stgy*(0:((num_pontos_stgy-1)));
P2 = abs(Y/num_pontos_stgy);
P1 = P2(1:num_pontos_stgy/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = freq_amostragem/num_pontos_stgy*(0:(num_pontos_stgy/2));
plot(f, P1);

% figure;
% % plot 1 (base)
% subplot(1,2,1);
% plot(aux_base,P1_base,"blue");
% title("Sem estratégia");
% xlabel('Frequência [Hz]'); ylabel('Amplitude [p.u]');
% xlim([0 500]);
% grid on;
% 
% % plot 2 (estratégia)
% subplot(1,2,2);
% plot(aux_stgy,P1_stgy,"red");
% title("Com estratégia");
% xlabel('Frequência [Hz]'); ylabel('Amplitude [p.u]');
% xlim([0 500]);
% grid on;

%plot(tempo_stgy, amplitude_stgy);
%periodogram(amplitude_stgy, [], num_pontos_stgy);