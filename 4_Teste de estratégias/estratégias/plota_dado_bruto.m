clear all;
data = readmatrix('Novos dados\0.6\rpoc\pot_ativa.csv');


base_inf = 38069; base_sup = 65677;
%base_inf = 0; base_sup = 656777;
%base_inf = 41844; base_sup = 63277;

%stgy = data((data(:, 1) >= base_inf) & (data(:, 1) <= base_sup), :);
stgy = data((data(:, 1) >= base_inf) & (data(:, 1) <= base_sup), :);

freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;
resultado_pu = 0;

amplitude1 = stgy(:,2);
tempo1 = (stgy(:,1)-stgy(1,1)); %* periodo_amostragem;

figure(1);
plot(tempo1, amplitude1);

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
