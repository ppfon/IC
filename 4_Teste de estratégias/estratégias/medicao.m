clear workspace;
freq_amostragem = 50e3;
periodo_amostragem = 1/freq_amostragem;
resultado_pu = 0;

data = readmatrix("Teórico\F0000MTH.CSV");
tempo = data(:,4);
amp = data(:,5);
tempo1 = (tempo(:,1)+0.025);
plot(tempo1, amp);

[amp1, fase, freq] = calcula_espectro(amp, periodo_amostragem, 0);
plot(freq, amp1);