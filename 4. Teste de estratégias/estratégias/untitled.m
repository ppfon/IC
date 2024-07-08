%le_stgy = load("pratica\rpoc\reativo\teste.mat", "base");

freq_amostragem = 10e3;
periodo_amostragem = 1/freq_amostragem;
L = 14e3;

t = (0:L-1)*periodo_amostragem;
S =  0.8 + 0.7*sin(2*pi*50*t) + sin(2*pi*300*t);
%plot(t, S);
[amp, fase, freq] = plota_espectro(S, periodo_amostragem, 500);

% anal(S, periodo_amostragem, 600);
% title('Fourier Analyis of the Rotor Voltage')
% xlabel('Frequency (Hz)')
% ylabel('Amplitude (% of the Fundamental)')

% Y = abs(fft(S, L))/L;
% espectro = Y(1:L/2+1);
% espectro(2:end-1) = 2*espectro(2:end-1);
% f = freq_amostragem/L*(0:(L/2));
% 
% % anal(S, periodo_amostragem,5000);
% 
% figure 
% plot(f,espectro); 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')

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