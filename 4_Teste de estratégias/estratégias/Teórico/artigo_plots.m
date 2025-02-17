clear workspace; clc; close all;

%% Frequency, characteristic angle, time vector
f = 1;  w = 2*pi*f; 
theta_c = 2*pi/3; a = exp(2*pi*j/3);
theta_i = pi/6;
t = linspace(0,1,100);

%% Voltages and currents (abc)
deseq_v = 0.4; deseq_i = 1;
amp_va = 1*deseq_v; amp_vb = 1*deseq_v; amp_vc = 1;
amp_ia = 1*deseq_i; amp_ib = 1*deseq_i; amp_ic = 1;

va = amp_va * exp(1j*(w*t)); %cos(w*t);
vb = amp_vb * exp(1*j*(w*t - theta_c));
vc = amp_vc * exp(1*j*(w*t - 2*theta_c));

ia = amp_ia * exp(1*j*(w*t + theta_i)); %cos(w*t - theta_i);
ib = amp_ib * exp(1*j*(w*t - theta_c + theta_i)); %cos(w*t - theta_c - theta_i);
ic = amp_ic * exp(1*j*(w*t - 2* theta_c + theta_i)); % cos(w*t - 2*theta_c - theta_i);

%% 3-phase arrays (3 x N)
vabc = [va; vb; vc];  % vabc
%(:,n) => [v_a(n); v_b(n); v_c(n)]
iabc = [ia; ib; ic];  % i(:,n) => [i_a(n); i_b(n); i_c(n)]
vabc_real = real(vabc); iabc_real = real(iabc);

%% Instantaneous active power p, reactive power vector q
% p = dot(v_real, i_real);      % 1 x N (dot product per column)
% q = cross(v_real, i_real);    % 3 x N (cross product per column)
% q_n = vecnorm(q);
p = dot(vabc_real, iabc_real);      % 1 x N (dot product per column)
q = cross(vabc_real, iabc_real);    % 3 x N (cross product per column)
q_n = vecnorm(q);

%% Compute ip and iq at each time step
% dot(vabc
%,vabc
%) is also 1 x N, so use elementwise division (./)
ip = (p .* vabc) ./ dot(vabc,vabc);      % 3 x N
iq = cross(q, vabc) ./ dot(vabc,vabc);   % 3 x N

%% Sequence components (Fortescue theorem) and voltage unbalaced factor
% T_seq = 1/3 *   [1,    1,    1;
%                  1,    a,   a^2;
%                  1,   a^2,   a];
% 
% v_seq = T_seq * vabc
%; v_pos = v_seq(2,:); v_neg = v_seq(3,:);
% u = mean(abs(v_neg)./abs(v_pos));
% i_seq = T_seq * i; i_pos = i_seq(2,:); i_neg = v_seq(3,:);

%% Clarke transform 
n_clarke = sqrt(2/3); % power invariant
T_clarke = [1 -0.5 -0.5; 0 sqrt(3)/2 -sqrt(3)/2];
T_inv = [2/3 0; -1/3 sqrt(3)/3; -1/3 -sqrt(3)/3];
v_clarke = n_clarke * T_clarke * vabc_real;
i_clarke = n_clarke * T_clarke * iabc_real;

%% Clarke + Fortescue 
q_op = exp(-1*j*pi/2);

v_clarke_pos = 0.5 * [1, -q_op; q_op, 1] * v_clarke; % v_{alpha+,beta+}
v_clarke_neg = 0.5 * [1, q_op; -q_op, 1] * v_clarke; % v_{alpha-,beta-}
v_alpha = [v_clarke_pos(1,:) + v_clarke_neg(1,:)]; % v_{alpha} = v_{alpha+} + v_{alpha-}
v_beta = [v_clarke_neg(2,:) + v_clarke_neg(2,:)]; % v_{beta} = v_{beta+} + v_{beta-}
v_alphabeta = real([v_alpha; v_beta]); % v_{alpha,beta}
%v_pos = v_clarke_pos; v_neg = v_clarke_neg;
v_pos = [v_clarke_pos(1,:); v_clarke_neg(2,:)]; 
v_neg = [v_clarke_pos(2,:); v_clarke_neg(1,:)]; 

i_clarke_pos = 0.5 * [1, -q_op; q_op, 1] * i_clarke; % i_{alpha+,beta+}
i_clarke_neg = 0.5 * [1, q_op; -q_op, 1] * i_clarke; % i_{alpha-,beta-}
i_alpha = [i_clarke_pos(1,:) + i_clarke_neg(1,:)]; % i_{alpha} = i_{alpha+} + i_{alpha-}
i_beta = [i_clarke_neg(2,:) + i_clarke_neg(2,:)]; % i_{beta} = i_{beta+} + i_{beta-}
i_alphabeta = real([i_alpha; i_beta]); % i_{alpha,beta}
i_pos = i_clarke_pos; i_neg = i_clarke_neg;

figure(1);
subplot(2,1,1);
plot(v_pos(2,:), v_pos(1,:)); hold on;
plot(v_neg(2,:), v_neg(1,:), '--', 'LineWidth', 1.5);
plot(v_alphabeta(2,:), v_alphabeta(1,:)); hold off; grid on;
legend;
subplot(2,1,2);
plot(i_pos(2,:), i_pos(1,:)); hold on;
plot(i_neg(2,:), i_neg(1,:), '--', 'LineWidth', 1.5);
plot(i_alphabeta(2,:), i_alphabeta(1,:)); hold off; grid on;
legend;
%% Figure 1: time-domain plot displaying one voltage and current cycle
% figure(1);
% subplot(2,1,1);
% plot(t, real(vabc
%));
% xlabel('time'); 
% ylabel('voltage');
% legend('v_a','v_b','v_c','Location','best');
% 
% subplot(2,1,2);
% plot(t, real(i));
% xlabel('time'); 
% ylabel('current');  % changed label to "current" for clarity
% legend('i_a','i_b','i_c','Location','best');

%% Figure 2: animate the instantaneous 3D vectors
%% Create Figure and Set Key Press Function
%figure(2);
%set(gcf, 'WindowButtonDownFcn', @togglePause); % Detect mouse click

%global isPaused;
%isPaused = false; % Control variable for pausing

%% Determine Fixed Axis Limits
all_vectors = [vabc, iabc, ip, iq, q]; % Concatenates all vectors
max_limit = max(abs(all_vectors), [], 'all') * 1.1; % Find max value and add margin
min_limit = -max_limit; % Make it symmetric

%% Animation Loop
%animation = 'ac';
%run('plots');