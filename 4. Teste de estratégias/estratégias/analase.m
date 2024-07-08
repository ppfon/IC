%Analise dos dados segundo o artigo do Lopez
clear
clc
close all

Aquisicao = load(['C1Input0000' int2str(0) '.dat']);
t = Aquisicao(:,1)-Aquisicao(1,1);
PWM = Aquisicao(:,2);
T = t(2)-t(1);

figure
plot (t, PWM)
grid
title('PWM')
xlabel('Time (s)')
ylabel('Amplitude (V)')
hold on

anal(PWM,T,1000);
title('Fourier Analyis of the Rotor Voltage')
xlabel('Frequency (Hz)')
ylabel('Amplitude (% of the Fundamental)')

Fs = 1/T;                    % Sampling frequency
L = length(PWM);             % Length of signal
NFFT = 2^nextpow2(L);        % Next power of 2 from length of y
Y = fft(PWM,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure 
hold on
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')