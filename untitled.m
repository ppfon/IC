% MATLAB code to calculate filter coefficients c0 and c1 for a first-order
% low-pass filter (Euler forward discretization), then plot its frequency 
% response with the x-axis in Hz.

% Sampling parameters
fsample = 9000;         % Sampling frequency in Hz
Ts = 1/fsample;         % Sampling period in seconds

% Desired cutoff frequency
fc = 2.5;               % Cutoff frequency in Hz

%--------------------------------------------------------------------------
% 1) Compute the time constant of the analog filter:
%       tau = 1 / (2*pi*fc)
% 2) Use the forward Euler method to discretize:
%       y[n] = y[n-1] + (Ts/tau)*(x[n] - y[n-1])
%            = (1 - alpha)*y[n-1] + alpha*x[n]
%    where alpha = Ts / tau = Ts * (2*pi*fc).
%--------------------------------------------------------------------------
tau = 1/(2*pi*fc);       % Analog time constant
alpha = Ts / tau;        % Discretization factor

% The discrete-time filter can be written in the form:
%    y[n] = c0*x[n] + c1*y[n-1],
% where
%    c0 = alpha,
%    c1 = 1 - alpha.
c0 = alpha;
c1 = 1 - alpha;

% Display the calculated coefficients
fprintf('Calculated filter coefficients:\n');
fprintf('c0 = %.8f\n', c0);
fprintf('c1 = %.8f\n', c1);

%--------------------------------------------------------------------------
% Transfer Function in z-domain:
%    H(z) = c0 / (1 - c1*z^(-1))
% Hence, the numerator and denominator polynomials for freqz are:
%    b = [c0]
%    a = [1, -c1]
%--------------------------------------------------------------------------
b = c0;
a = [1, -c1];

%--------------------------------------------------------------------------
% Frequency Response Calculation
%--------------------------------------------------------------------------
nFreqPoints = 4096;        % Number of frequency points for plotting
[H, f] = freqz(b, a, nFreqPoints, fsample);

%--------------------------------------------------------------------------
% Plot the Frequency Response
%--------------------------------------------------------------------------
figure;
subplot(2,1,1)
plot(f, 20*log10(abs(H)));
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Magnitude Response of the First-Order Low-Pass Filter');
grid on;
xlim([0, 50]);  % Adjust as needed to focus on the low-frequency range

subplot(2,1,2)
plot(f, angle(H));
xlabel('Frequency (Hz)');
ylabel('Phase (radians)');
title('Phase Response of the First-Order Low-Pass Filter');
grid on;
xlim([0, 50]);  % Adjust as needed
