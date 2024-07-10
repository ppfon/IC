data = readmatrix('9k/bpsc/q2000p0/bpsc_q2000_p0_d04pu_reativo.csv');
%data2 = readmatrix('9k/pnsc/q2000p0/pnsc_q2000_p0_d04pu_reativo.csv');

freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;
% stgy = 299
base_inf = 59699; base_sup = 89137;
base = data((data(:, 1) >= base_inf) & (data(:, 1) <= base_sup), :);


% tempo = (base(:,1)-base(1))*periodo_amostragem;
% amplitude = base(:,2);
% num_pontos = numel(tempo);
% 
% Y = fft(amplitude);
% aux = freq_amostragem/num_pontos*(0:(num_pontos/2));
% P2 = abs(Y/num_pontos);
% P1 = P2(1:num_pontos/2+1);
% P1(2:end-1) = 2*P1(2:end-1);

%plot(aux,P1,"LineWidth",3);
figure(1);
plot(data(:,1), data(:,2));

figure(2);
%plot(data2(:,1), data2(:,2));
%plot(tempo, amplitude);
plot(base(:,1), base(:,2));