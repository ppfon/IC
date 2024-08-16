%data = readmatrix('Novos dados\pnsc\q2000p0\pot_reativa.csv');
load_data = load('Novos dados\aarc\q2000p0\ativo\base.mat');
data = load_data.stgy;
load_base = load('Dados\9k\aarc\q2000p0\ativo\base.mat');
data2 = load_base.base;

data3 = readmatrix('Novos dados\bpsc\q2000p0\pot_ativa.csv');
data4 = readmatrix('correntes\ativo_deseq_duas_06.csv');

base_inf = 16359; base_sup = 29933;

base = data2((data2(:, 1) >= base_inf) & (data2(:, 1) <= base_sup), :);
stgy = data((data(:, 1) >= base_inf) & (data(:, 1) <= base_sup), :);

freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;
resultado_pu = 0;

amplitude1 = data(:,2);
tempo1 = (data(:,1)-data(1,1))* periodo_amostragem;

amplitude2 = data2(:,2);
tempo2 = (data2(:,1)-data2(1,1)) * periodo_amostragem;

figure(1);
%plot(tempo1, amplitude1);

% amplitude3 = data3(:,2);
% tempo3 = (data3(:,1)-data3(1,1)) * periodo_amostragem;
% 
% amplitude4 = data4(:,2);
% tempo4 = (data4(:,1)-data4(1,1)) * periodo_amostragem;

% figure(1);
subplot(1,2,1);
[amp, fase, freq] = calcula_espectro(amplitude1, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title("Ativo - sem estratégia");
xlabel('Frequência [Hz]'); ylabel('Amplitude [W]');
grid on; 

subplot(1,2,2);
[amp, fase, freq] = calcula_espectro(amplitude2, periodo_amostragem, resultado_pu);
plot(freq, amp, 'g'); grid on; 

% subplot(1,2,2);
% 
% [amp, fase, freq] = calcula_espectro(amplitude3, periodo_amostragem, resultado_pu);
% plot(freq, amp, 'r');
% title("Ativo - sem estratégia");
% xlabel('Frequência [Hz]'); ylabel('Amplitude [W]');
% grid on; 
% hold on;
% [amp, fase, freq] = calcula_espectro(amplitude4, periodo_amostragem, resultado_pu);
% plot(freq, amp, 'g'); 
