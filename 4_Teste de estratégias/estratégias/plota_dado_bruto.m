clear all;
data = readmatrix('Novos dados\pnsc\0.1818\q0p1500\pot_reativa.csv');
%data = dlmread('Novos dados/apoc/0.3333/q1500p0/pot_ativa.csv', ';', 1, 0);

%base_inf = 39949; base_sup = 60771;
base_inf = 39993; base_sup = 78781;
%base_inf = 33277; base_sup = 69195;

stgy = data((data(:, 1) >= base_inf) & (data(:, 1) <= base_sup), :);
%base = data((data(:, 1) >= base_inf) & (data(:, 1) <= base_sup), :);

freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;
resultado_pu = 0;

amplitude1 = stgy(:,2);
tempo1 = (stgy(:,1)-stgy(1,1)); %* periodo_amostragem;

figure(1);
plot(tempo1, amplitude1);
grid on;
% amplitude3 = data3(:,2);
% tempo3 = (data3(:,1)-data3(1,1)) * periodo_amostragem;
%
% amplitude4 = data4(:,2);
% tempo4 = (data4(:,1)-data4(1,1)) * periodo_amostragem;



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
