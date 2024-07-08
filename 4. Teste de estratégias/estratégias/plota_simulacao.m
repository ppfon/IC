data = readmatrix('rpoc/9k/aarc/q0p2000/aarc_q0_p2000_d04pu_reativo.csv');
%data2 = readmatrix('rpoc/rpoc_q1000_p2000_d04pu_reativo.csv');

freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;
% stgy = 299
base_inf = 57568; base_sup = 71411;
base = data((data(:, 1) >= base_inf) & (data(:, 1) < base_sup), :);


tempo = (base(:,1)-base(1))*periodo_amostragem;
amplitude = base(:,2);
num_pontos = numel(tempo);

Y = fft(amplitude);
aux = freq_amostragem/num_pontos*(0:(num_pontos/2));
P2 = abs(Y/num_pontos);
P1 = P2(1:num_pontos/2+1);
P1(2:end-1) = 2*P1(2:end-1);

%plot(aux,P1,"LineWidth",3);
figure(1);
plot(data(:,1), data(:,2));

figure(2);
%plot((data2(:,1)-data(1))*periodo_amostragem, data2(:,2));
%plot(tempo, amplitude);
plot(base(:,1), base(:,2));