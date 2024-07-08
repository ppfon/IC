%
% Fourier analysis using MATLAB's FFT function
% Define path with 'path'
% Load files with 'load' filename.xxx
% Analyze types (filename, sampling time, frequency range of analysis)

function [ampl, ha, freq] = anal(sig, stepsize, harm)

    points = 2^nextpow2(length(sig));
    points = length(sig);
    
    ffts = fft(sig, points) / length(sig);
    
    % frequency axis
    freq = 1/(2*stepsize) * linspace(0, 1, points/2);
    % freq = 1/(stepsize*points) * (0:points-1);
    
    ampl = 2 * abs(ffts(1:points/2)) / max(sig);
    % ampl = abs(ffts) / points * 2;
    % ampl = 100 * ampl / max(ampl); % Normalization in percent
    
    ha = angle(ffts');
    
    % for j = 1:points
    %     if ampl(j) < 1
    %         ampl(j) = 0;
    %     end
    % end
    freq1 = 0:points-1;
    % bar(freq(1:points/2-1), ampl(1:points/2-1));
    % bar(freq1(1:harm), (ampl(1:harm) / ampl(2)));
    % subplot(2, 1, 1);
    figure;
    bar(freq(1:harm), ampl(1:harm));
    grid;
    % figure
    % plot(freq(1:harm), ampl(1:harm));
    % grid
    % subplot(2, 1, 2);
    % bar(freq1(1:harm), (ha(1:harm)));
    % grid
    % Freq = [Freq]
    %
    