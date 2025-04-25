%% Sampling and Fundamental Frequency Parameters
freq_amostragem = 9e3;           % Sampling frequency (Hz)
T_sample = 1 / freq_amostragem;  % Sampling period (s)
fundamental_freq = 60;           % Fundamental frequency (Hz)

%% Load Data (using first 30000 samples)
le_ia = readmatrix('Novos estranhos_apagar\aarc\0.3333\q1000p1000\ia.csv');
le_ib = readmatrix('Novos estranhos_apagar\aarc\0.3333\q1000p1000\ib.csv');

sup = 0; inf_a = 0; inf_b = 0; diff = inf_b - inf_a;
amplitude_ia_iarc = le_ia(160:19560+160, 2);
amplitude_ib_iarc = le_ib(160+48+100:19560+160+48+100, 2);
amplitude_ic_iarc = -(amplitude_ia_iarc + amplitude_ib_iarc);
tempo = (0:length(amplitude_ia_iarc)-1)'/ freq_amostragem;

ia_ts_iarc = timeseries(amplitude_ia_iarc, tempo);
ib_ts_iarc = timeseries(amplitude_ib_iarc, tempo);
ic_ts_iarc = timeseries(amplitude_ic_iarc, tempo);

amplitude_ia_aarc = le_ia(40441:60000, 2);
%amplitude_ib = le_ib(5584:30051, 2);
amplitude_ib_aarc = le_ib(40441+50+100:60000+50+100,2);
amplitude_ic_aarc = -(amplitude_ia_aarc + amplitude_ib_aarc);



%amplitude_ic = amplitude_ic([17:length(amplitude_ic), 1:16]);

%% Create Time Vectors and Timeseries
tempo = (0:length(amplitude_ia_aarc)-1)'/ freq_amostragem;  % Assume both have same length now
ia_ts_aarc = timeseries(amplitude_ia_aarc, tempo);
ib_ts_aarc = timeseries(amplitude_ib_aarc, tempo);
ic_ts_aarc = timeseries(amplitude_ic_aarc, tempo);

ia_freq =  abs(fft(ia_ts_aarc.Data, length(ia_ts_aarc.Data)))/length(ia_ts_aarc.Data);
    ia_freq = ia_freq(1:length(ia_ts_aarc.Data)/2+1);
    ia_freq(2:end-1) = 2*ia_freq(2:end-1);
% fund = 163
freq = 9000 / length(ia_ts_aarc.Data) * (0:(length(ia_ts_aarc.Data)/2));
thd_a_db_iarc = thd(ia_ts_iarc.Data, 9000, 50); thd_a_iarc = 100 * (10^(thd_a_db_iarc/20));
thd_b_db_iarc = thd(ib_ts_iarc.Data, 9000, 50); thd_b_iarc = 100 * (10^(thd_b_db_iarc/20));
thd_c_db_iarc = thd(ic_ts_iarc.Data, 9000, 50); thd_c_iarc = 100 * (10^(thd_c_db_iarc/20));
disp(thd_a_iarc); disp(thd_b_iarc); disp(thd_c_iarc);

thd_a_db_aarc = thd(ia_ts_aarc.Data, 9000, 50); thd_a_aarc = 100 * (10^(thd_a_db_aarc/20));
thd_b_db_aarc = thd(ib_ts_aarc.Data, 9000, 50); thd_b_aarc = 100 * (10^(thd_b_db_aarc/20));
thd_c_db_aarc = thd(ic_ts_aarc.Data, 9000, 50); thd_c_aarc = 100 * (10^(thd_c_db_aarc/20));
disp(thd_a_aarc); disp(thd_b_aarc); disp(thd_c_aarc);


%% Plot the Results
figure('Color', 'white');
tiledlayout(1,2, 'TileSpacing','Compact','Padding','Compact');
nexttile
plot(ia_ts_iarc.Time, ia_ts_iarc.Data, 'r', 'LineWidth', 3); hold on;
plot(ib_ts_iarc.Time, ib_ts_iarc.Data, 'b', 'LineWidth', 3); %, 'DisplayName', 'Ib');
plot(ic_ts_iarc.Time, ic_ts_iarc.Data, 'k', 'LineWidth', 3) %; , 'DisplayName', 'Ic');
title('IARC', 'Interpreter', 'latex', 'FontSize', 24);
ylabel('$\mathbf{i}_{g,\mathrm{abc}}$ [A]', 'Interpreter', 'latex', 'FontSize', 24);
xlabel('Time $\; [s]$','Interpreter','latex', 'FontSize', 24);
legend('$i_\mathrm{a} (33.74\%)$', '$i_\mathrm{b} (35.88\%) $', '$i_\mathrm{c} (22.78 \%)$' ,'Location', 'northeast', 'FontSize', 24, 'interpreter', 'latex'); grid on;
h = gca;
h.YAxis.FontSize = 24;
h.XAxis.FontSize = 24;
h.GridLineWidth = 3;
xlim([0.4357 0.5357]); ylim([-25 25]); xticks([0.43:0.01:0.53]); yticks([-16:4:16]);

nexttile
plot(ia_ts_aarc.Time, ia_ts_aarc.Data, 'r', 'LineWidth', 3); hold on; %, 'DisplayName', 'Ia'); hold on;%
plot(ib_ts_aarc.Time, ib_ts_aarc.Data, 'b', 'LineWidth', 3); %, 'DisplayName', 'Ib');
plot(ic_ts_aarc.Time, ic_ts_aarc.Data, 'k', 'LineWidth', 3) %; , 'DisplayName', 'Ic');
set(gcf,'color','white');
xlim([0.4357 0.5357]);
xlabel('Time $\; [s]$','Interpreter','latex', 'FontSize', 24); ylabel('$\mathbf{i}_{g,\mathrm{abc}}$ [A]','Interpreter','latex', 'FontSize', 24);
xticks([0.43:0.01:0.53]); yticks([-16:4:16]);% Define os limites do eixo x
h = gca;
h.YAxis.FontSize = 24;
h.XAxis.FontSize = 24;
h.GridLineWidth = 3;
title('AARC', 'Interpreter', 'latex', 'FontSize', 24); ylim([-25 25]);
legend('$i_\mathrm{a} (6.66 \%)$', '$i_\mathrm{b} (8.87 \%)$', '$i_\mathrm{c} (7.36 \%)$' ,'Location', 'northeast', 'FontSize', 24, 'interpreter', 'latex'); grid on;

% figure(2);
% thd(ia_ts_aarc.Data, 9000, 50);
% figure(2);
% plot(freq, ia_freq);
% xlim([0 250]); xticks(0:10:250);
% thd(ib_ts.Data, 9000);
% 

% 
% fprintf('%d, %d, %d\n ', thd_a, thd_b, thd_c);
