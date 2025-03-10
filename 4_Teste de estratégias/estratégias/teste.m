%% Clear workspace and figures
clear; close all; clc;

%% Define the user-specified parameters
% Available main strategies: 'aarc', 'apoc', 'bpsc', 'pnsc', 'rpoc'
mainStrategy = 'rpoc';  

% Available unbalance factors: '0.1818', '0.3333', '0.5714'
unbalanceFactor = '0.3333';  

% Available power references: 'q0p1500', 'q1500p0', 'q1000p1000'
powerReference = 'q0p1500';  

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
baseFolder = 'Novos dados';
freq_amostragem = 9e3; 
periodo_amostragem = 1 / freq_amostragem;
resultado_pu = 0;

%% Build file paths for both 'ativo' and 'reativo' folders
ativoPath   = fullfile(baseFolder, mainStrategy, unbalanceFactor, powerReference, 'ativo');
reativoPath = fullfile(baseFolder, mainStrategy, unbalanceFactor, powerReference, 'reativo');

%% Load data from the "ativo" branch
% Load the base data
le_base_ativo = load(fullfile(ativoPath, 'base.mat'), 'base');
base_ativo = le_base_ativo.base;

% Load the strategy data
le_stgy_ativo = load(fullfile(ativoPath, 'stgy.mat'), 'stgy');
stgy_ativo = le_stgy_ativo.stgy;

% Extract amplitude data (assumed to be in the second column)
amplitude_base_ativo = base_ativo(:,2);
amplitude_stgy_ativo = stgy_ativo(:,2);

%% Load data from the "reativo" branch
% Load the base data
le_base_reativo = load(fullfile(reativoPath, 'base.mat'), 'base');
base_reativo = le_base_reativo.base;

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
[amp, fase, freq] = calcula_espectro(amplitude_base_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title('Potência ativo');
xlabel('Frequência [Hz]');
ylabel('Amplitude [W]');
xlim([0 480]);
grid on;
hold on;
[amp, fase, freq] = calcula_espectro(amplitude_stgy_ativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'b');
% Dynamic legend for active branch using the active power reference
legend( sprintf('%s | P_{ref} = %s kW | Sem estratégia', upper(mainStrategy), activeRef), ...
        sprintf('%s | P_{ref} = %s kW | Com estratégia', upper(mainStrategy), activeRef) );
hold off;

% Plot for the reactive (reativo) branch
subplot(1,2,2);
[amp, fase, freq] = calcula_espectro(amplitude_base_reativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'r');
title('Potência reativa');
xlabel('Frequência [Hz]');
ylabel('Amplitude [VAr]');
xlim([0 480]);
grid on; hold on;
[amp, fase, freq] = calcula_espectro(amplitude_stgy_reativo, periodo_amostragem, resultado_pu);
plot(freq, amp, 'b');
% Dynamic legend for reactive branch using the reactive power reference
legend( sprintf('%s | Q_{ref} = %s kVAr | Sem estratégia', upper(mainStrategy), reactiveRef), ...
        sprintf('%s | Q_{ref} = %s kVAr | Com estratégia', upper(mainStrategy), reactiveRef) );
hold off;

%% Compute time vectors for time domain plots
tempo_base_ativo  = (0:length(amplitude_base_ativo)-1) / freq_amostragem;
tempo_stgy_ativo  = (0:length(amplitude_stgy_ativo)-1) / freq_amostragem;
tempo_base_reativo = (0:length(amplitude_base_reativo)-1) / freq_amostragem;
tempo_stgy_reativo = (0:length(amplitude_stgy_reativo)-1) / freq_amostragem;

%% Plot the time domain waveform for active branch
figure(2);
plot(tempo_base_ativo, amplitude_base_ativo, 'r');
titulo1 = sprintf('Potência ativa - %s - $P_{\\mathrm{ref}} = %s \\; \\mathrm{W}$', upper(mainStrategy), activeRef);
title(titulo1, 'Interpreter', 'latex');
xlabel('Tempo [s]');
ylabel('Amplitude [W]');
grid on; hold on;
plot(tempo_stgy_ativo, amplitude_stgy_ativo, 'b');
legend('Sem estratégia', 'Com estratégia');
hold off;

%% Plot the time domain waveform for reactive branch
figure(3);
plot(tempo_base_reativo, amplitude_base_reativo, 'r');
titulo2 = sprintf('Potência reativa - %s - $Q_{\\mathrm{ref}} = %s \\; \\mathrm{VAr}$', upper(mainStrategy), reactiveRef);
title(titulo2, 'Interpreter', 'latex');
xlabel('Tempo [s]');
ylabel('Amplitude [VAr]');
grid on; hold on;
plot(tempo_stgy_reativo, amplitude_stgy_reativo, 'b');
legend('Sem estratégia', 'Com estratégia');
hold off;
