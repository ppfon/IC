%% Sampling and Fundamental Frequency Parameters
freq_amostragem = 9e3;           % Sampling frequency (Hz)
T_sample = 1 / freq_amostragem;  % Sampling period (s)
fundamental_freq = 60;           % Fundamental frequency (Hz)
samples_per_cycle = freq_amostragem / fundamental_freq; % 150 samples per cycle

%% Load Data (using first 30000 samples)
le_ia = readmatrix('Novos Dados\bpsc\0.5714\q1000p1000\ia.csv');
le_ib = readmatrix('Novos Dados\bpsc\0.5714\q1000p1000\ib.csv');

sup = 30000; inf_a = 5533; inf_b = 5584; diff = inf_b - inf_a;
amplitude_ia = le_ia(5533:30000, 2);
%amplitude_ib = le_ib(5584:30051, 2);
amplitude_ib = le_ib(inf_b+50:30051+50,2);

%% Create Time Vectors and Timeseries
tempo = (0:length(amplitude_ia)-1)' / freq_amostragem;  % Assume both have same length now
ia_ts = timeseries(amplitude_ia, tempo);
ib_ts = timeseries(amplitude_ib, tempo);
ic_ts = timeseries(-(amplitude_ia + amplitude_ib), tempo);

ia_freq =  abs(fft(ia_ts.Data, length(ia_ts.Data)))/length(ia_ts.Data);
    ia_freq = ia_freq(1:length(ia_ts.Data)/2+1);
    ia_freq(2:end-1) = 2*ia_freq(2:end-1);
% fund = 163
freq = 9000 / length(ia_ts.Data) * (0:(length(ia_ts.Data)/2));

% Extract the fundamental amplitude
A1 = abs(ia_freq(163));

% Initialize the sum of squares for the harmonics
sum_harmonics = 0;

% Determine the maximum harmonic to consider; this depends on your signal bandwidth
% For instance, if you consider harmonics up to the 10th harmonic:
maxHarmonic = 70;

for k = 2:maxHarmonic
    harmonicIndex = 163 * k; % approximate index for kth harmonic
    % Ensure harmonicIndex does not exceed the length of the FFT result
    if harmonicIndex <= length(ia_freq)
        Ak = abs(ia_freq(harmonicIndex));
        sum_harmonics = sum_harmonics + Ak^2;
    end
end

% Calculate THD (as a ratio)
THD_ratio = sqrt(sum_harmonics / (A1^2));

% Convert THD to a percentage
THD_percent = THD_ratio * 100;

% Display the results
fprintf('THD (ratio): %f\n', THD_ratio);
fprintf('THD (%%): %f\n', THD_percent);

%% Plot the Results
figure(1);
%subplot(1,2,1);
plot(ia_ts.Time, ia_ts.Data, 'r', 'LineWidth', 3); hold on; %, 'DisplayName', 'Ia'); hold on;%
% hold on;
%subplot(1,2,2);
plot(ib_ts.Time, ib_ts.Data, 'b', 'LineWidth', 3); %, 'DisplayName', 'Ib');
plot(ic_ts.Time, ic_ts.Data, 'k', 'LineWidth', 3) %; , 'DisplayName', 'Ic');
set(gcf,'color','white');
%plot(ic_sync, 'g', 'LineWidth', 1.2, 'DisplayName', 'Ic Sync');
%xlabel('Time [s]'); ylabel('Current [A]'); 
xlim([0.184222 0.22]);
xlabel('Time $\; s$','Interpreter','latex', 'FontSize', 24); ylabel('$A$','Interpreter','latex', 'FontSize', 24);
xticks([0.18:0.002:0.22]); ylim([-16 16]); yticks([-16:2:16]);% Define os limites do eixo x
h = gca;
h.YAxis.FontSize = 24;
h.XAxis.FontSize = 24;
h.GridLineWidth = 3;
title('BPSC $ \mathbf{i}_{\mathrm{abc}} $ currents ', 'Interpreter', 'latex', 'FontSize', 24);
%title('Original Synchronized Signals');
legend('$i_\mathrm{a} $', '$i_\mathrm{b}$', '$i_\mathrm{c}$' ,'Location', 'northeast', 'FontSize', 14, 'interpreter', 'latex'); grid on;

figure(2);
plot(freq, ia_freq);
xlim([0 250]); xticks(0:10:250);

thd_a_db = thd(ia_ts.Data, 9000, 70); thd_a = 100 * (10^(thd_a_db/20));
thd_b_db = thd(ib_ts.Data, 9000, 70); thd_b = 100 * (10^(thd_b_db/20));
thd_c_db = thd(ic_ts.Data, 9000, 70); thd_c = 100 * (10^(thd_c_db/20));

fprintf('%d, %d, %d\n ', thd_a, thd_b, thd_c);
