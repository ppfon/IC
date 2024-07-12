data = readmatrix('9k/rpoc/rpoc_q1000_p2000_d04pu_reativo.csv');
%data2 = readmatrix('9k/pnsc/q2000p0/pnsc_q2000_p0_d04pu_reativo.csv');

freq_amostragem = 9e3;
periodo_amostragem = 1/freq_amostragem;

base_inf = 31294; base_sup = 53112;
base = data((data(:, 1) >= base_inf) & (data(:, 1) <= base_sup), :);

figure(1);
plot(data(:,1), data(:,2));

figure(2);
%plot(data2(:,1), data2(:,2));
%plot(tempo, amplitude);
plot(base(:,1), base(:,2));