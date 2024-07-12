%le_stgy = load("pratica\rpoc\reativo\teste.mat", "base");

freq_amostragem = 10e3;
periodo_amostragem = 1/freq_amostragem;
L = 14e3;

t = (0:L-1)*periodo_amostragem;
S =  0.8 + 0.7*sin(2*pi*50*t) + sin(2*pi*300*t);
%plot(t, S);
[amp, fase, freq] = calcula_espectro(S, periodo_amostragem, 0);
plot(freq, amp);

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