%% Clear workspace and figures
clear; close all; clc;

%% Define the user-specified parameters
% Available main strategies: 'aarc', 'apoc', 'bpsc', 'pnsc', 'rpoc'
mainStrategy = 'apoc';  

% Available unbalance factors: '0.1818', '0.3333', '0.5714'
unbalanceFactor = '0.3333';  

% Available power references: 'q0p1500', 'q1500p0', 'q1000p1000'
powerReference = 'q1000p1000';  

%% Parse the powerReference string to extract reactive and active references
% The expected format is 'q<number1>p<number2>' where:
%   - number1 corresponds to the reactive power reference (in kVAr)
%   - number2 corresponds to the active power reference (in kW)
tokens = regexp(powerReference, '^q(\d+)p(\d+)$', 'tokens');
if isempty(tokens)
    error('Invalid powerReference format. Expected format like "q0p1500".');
else
    reactiveRef = tokens{1}{1};  % e.g., '0'
    activeRef   = tokens{1}{2};  % e.g., '1500'
end

%% Define base folder and sampling parameters
baseFolder = 'Novos estranhos_apagar';
freq_amostragem = 9e3; 
periodo_amostragem = 1 / freq_amostragem;
resultado_pu = 0;

%% Build file paths for both 'ativo' and 'reativo' folders
ativoPath   = fullfile(baseFolder, mainStrategy, unbalanceFactor, powerReference, 'ativo');
reativoPath = fullfile(baseFolder, mainStrategy, unbalanceFactor, powerReference, 'reativo');

%% Load data from the "ativo" branch
% Load the base data
%le_base_ativo = load(fullfile(ativoPath, 'base.mat'), 'base');
le_base_ativo = load("Novos estranhos_apagar/rpoc/0.3333/q1000p1000/ativo/stgy.mat", "stgy");
base_ativo = le_base_ativo.stgy;

% Load the strategy data
le_stgy_ativo = load(fullfile(ativoPath, 'stgy.mat'), 'stgy');
stgy_ativo = le_stgy_ativo.stgy;

% Extract amplitude data (assumed to be in the second column)
amplitude_base_ativo = base_ativo(:,2);
amplitude_stgy_ativo = stgy_ativo(:,2);

%% Load data from the "reativo" branch
% Load the base data
%le_base_reativo = load(fullfile(reativoPath, 'base.mat'), 'base');
le_base_reativo = load("Novos estranhos_apagar/rpoc/0.3333/q1000p1000/reativo/stgy.mat", "stgy");
base_reativo = le_base_reativo.stgy;

% Load the strategy data
le_stgy_reativo = load(fullfile(reativoPath, 'stgy.mat'), 'stgy');
stgy_reativo = le_stgy_reativo.stgy;

% Extract amplitude data (assumed to be in the second column)
amplitude_base_reativo = base_reativo(:,2);
amplitude_stgy_reativo = stgy_reativo(:,2);

%% Compute and plot the frequency domain spectrum

% Create a figure for frequency domain plots
figure(1);

% Plot for the active (ativo) branch
subplot(1,2,1);
[amp_reativo_base, fase, freq] = calcula_espectro(amplitude_base_reativo, periodo_amostragem, resultado_pu);
plot(freq, amp_reativo_base, 'r');
title('Potência reativa');
xlabel('Frequência [Hz]');
ylabel('Amplitude [VAr]');
xlim([0 480]);
grid on; hold on;
[amp_reativo_stgy, fase, freq] = calcula_espectro(amplitude_stgy_reativo, periodo_amostragem, resultado_pu);
plot(freq, amp_reativo_stgy, 'b');
% Dynamic legend for reactive branch using the reactive power reference
legend( sprintf('%s | Q_{ref} = %s kVAr | Sem estratégia', upper(mainStrategy), reactiveRef), ...
        sprintf('%s | Q_{ref} = %s kVAr | Com estratégia', upper(mainStrategy), reactiveRef) );
hold off;


% Plot for the reactive (reativo) branch
subplot(1,2,2);
[amp_ativo_base, fase, freq] = calcula_espectro(amplitude_base_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp_ativo_base, 'r');
title('Potência ativo');
xlabel('Frequência [Hz]');
ylabel('Amplitude [W]');
xlim([0 480]);
grid on;
hold on;
[amp_ativo_stgy, fase, freq] = calcula_espectro(amplitude_stgy_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp_ativo_stgy, 'b');
% Dynamic legend for active branch using the active power reference
legend( sprintf('%s | P_{ref} = %s kW | Sem estratégia', upper(mainStrategy), activeRef), ...
        sprintf('%s | P_{ref} = %s kW | Com estratégia', upper(mainStrategy), activeRef) );
hold off;

%% Compute time vectors for time domain plots
tempo_base_ativo  = (0:length(amplitude_base_ativo)-1) / freq_amostragem;
tempo_stgy_ativo  = (0:length(amplitude_stgy_ativo)-1) / freq_amostragem;
tempo_base_reativo = (0:length(amplitude_base_reativo)-1) / freq_amostragem;
tempo_stgy_reativo = (0:length(amplitude_stgy_reativo)-1) / freq_amostragem;

figure('Color', 'white');
%% Plot the time domain waveform for active branch
tiledlayout(1,2, 'TileSpacing','Compact','Padding','Compact');
nexttile
plot(tempo_base_reativo, amplitude_base_reativo, 'r', 'LineWidth', 1.5);
titulo2 = sprintf('Reactive power', upper(mainStrategy), reactiveRef);
title(titulo2, 'Interpreter', 'latex', 'FontSize', 24);
xlabel('Time [s]');
ylabel('[VAr]','Interpreter','latex', 'FontWeight','bold', 'FontSize', 24);

grid on; hold on;
plot(tempo_stgy_reativo, amplitude_stgy_reativo, 'b', 'LineWidth', 1.5); xlim([0 2/60]);
legend('RPOC',upper(mainStrategy), 'FontSize', 24, 'interpreter', 'latex'); 
h = gca;
h.YAxis.FontSize = 24;
h.XAxis.FontSize = 24; ylim([-250 2500]);
h.GridLineWidth = 3; yticks([-250:250:2500]);
hold off;

%% Plot the time domain waveform for reactive branch
nexttile
plot(tempo_base_ativo, amplitude_base_ativo, 'r', 'LineWidth', 1.5);
titulo1 = sprintf('Active power', upper(mainStrategy), activeRef);
title(titulo1, 'Interpreter', 'latex', 'FontSize', 24);
xlabel('Time [s]');
ylabel('[W]','Interpreter','latex', 'FontWeight','bold', 'FontSize', 24);

grid on; hold on;
plot(tempo_stgy_ativo, amplitude_stgy_ativo, 'b', 'LineWidth', 1.5); xlim([0 2/60]);
legend('RPOC', upper(mainStrategy), 'FontSize', 24, 'interpreter', 'latex' ); %ylim([500 1500]);
h = gca;
h.YAxis.FontSize = 24; ylim([-250 2500]);
h.XAxis.FontSize = 24;
h.GridLineWidth = 3; yticks([-250:250:2500]);
hold off;


fprintf('Ativo: %d \n', amp_ativo_stgy(1,1));
fprintf('Reativo: %d \n ', amp_reativo_stgy(1,1));