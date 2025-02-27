clear workspace; clc; close all;

%% Frequency, characteristic angle, time vector
f = 1;  w = 2*pi*f; 
theta_c = 2*pi/3; a = exp(2*pi*j/3);
theta_i = 0;
t = linspace(0,1,100);

%% Voltages and currents (abc)
deseq_v = 0.8; deseq_i = 1;
amp_va = 1*deseq_v; amp_vb = 1*deseq_i; amp_vc = 1;
amp_ia = 1*deseq_i; amp_ib = 1*deseq_i; amp_ic = 1;

va = amp_va * exp(1j*(w*t)); 
vb = amp_vb * exp(1*j*(w*t - theta_c));
vc = amp_vc * exp(1*j*(w*t - 2*theta_c));

ia = amp_ia * exp(1*j*(w*t + theta_i)); 
ib = amp_ib * exp(1*j*(w*t - theta_c + theta_i)); 
ic = amp_ic * exp(1*j*(w*t - 2* theta_c + theta_i)); 

%% 3-phase arrays (3 x N)
vabc = [va; vb; vc]; iabc = [ia; ib; ic];  
vabc_real = real(vabc); iabc_real = real(iabc);

%% Voltage/current Sequence components (Fortescue theorem) and voltage unbalaced factor
T_seq = 1/3 *   [1,    1,    1;
                 1,    a,   a^2;
                 1,   a^2,   a];
v_seq = T_seq * vabc;
v_seq_pos = v_seq(2,:); v_seq_neg = v_seq(3,:);
u = mean(abs(v_seq_neg)./abs(v_seq_pos));
i_seq = T_seq * i; i_pos = i_seq(2,:); i_neg = v_seq(3,:);
theta_pos = angle(v_seq_pos(1,:)); theta_neg = angle(v_seq_neg(1,:));

%% Voltage in the synchornous reference frame (alpha-beta) for a 3 wire system
% A time invariant, null theta_{pos,neg} is assumed for simplicity
v_alpha_pos = abs(v_seq_pos(1,:)) .* cos(w*t); v_alpha_neg = abs(v_seq_neg(1,:)) .* cos(-w*t);
v_beta_pos = abs(v_seq_pos(1,:)) .* sin(w*t); v_beta_neg = abs(v_seq_neg(1,:)) .* sin(-w*t);
v_alpha = v_alpha_pos + v_alpha_neg; v_beta = v_beta_pos + v_beta_neg;

v_pos = [v_alpha_pos; v_beta_pos]; v_neg = [v_alpha_neg; v_beta_neg]; v = v_pos + v_neg;

%% Voltage orthogonal projection
T_orto = [0, 1; -1, 0];
v_orto_pos = T_orto * v_pos; v_orto_neg = T_orto * v_neg; v_orto = v_orto_pos + v_orto_neg;
v_orto_alpha = v_orto(1,:); v_orto_beta = v_orto(2,:);

%% Reference currents computation
% AARC -> kp = 1 = kq  | BPSC -> kp = 0 = kq | PNSC -> kp = -1 = kq
% APOC -> kp = -1, kq = -kp | RPOC -> kp = 1, kq = -kp
P_ref = 1; Q_ref = 1; kp = 0; kq = 0;
figure(1); 

v_pos_quad = v_pos(1,:).^2 + v_pos(2,:).^2; v_neg_quad = v_neg(1,:).^2 + v_neg(2,:).^2;

ip_ref = ((v_pos + kp .* v_neg) .* P_ref)./(v_pos_quad + kp .* v_neg_quad);
iq_ref = ((v_orto_pos + kq .* v_orto_neg) .* Q_ref)./(v_pos_quad + kq .* v_neg_quad);
i_ref = ip_ref + iq_ref;

subplot(1,1,1);
plot(ip_ref(2,:), ip_ref(1,:), '--', 'LineWidth', 1.5); hold on;
plot(iq_ref(2,:), iq_ref(1,:)); grid on; grid minor;
plot(i_ref(2,:), i_ref(1,:));
plot(v_orto_beta, v_orto_alpha);
plot(v_beta, v_alpha, '--', 'LineWidth', 1.5); hold off; 
xlabel('beta'); ylabel('alpha'); 
legend('ip_ref', 'iq_ref', 'i', 'V_orto','V');

% subplot(2,1,1);
% plot(v_alpha, v_beta); hold on;
% plot(v_alpha_pos, v_beta_pos); grid on;
% plot(v_alpha_neg, v_beta_neg); 
% plot(v_orto(1,:), v_orto(2,:));
% plot(v(1,:), v(2,:), '--', 'LineWidth', 1.5); hold off; 
% xlabel('alpha'); ylabel('beta'); legend('V_alpha_beta', 'V+','V-','V_orto','V');
%xlim([-1.4 1.4]); xticks([-1.5:0.5:1.5]);

% subplot(2,1,1);
% plot(dot(i_ref,v)); hold on;
% xlabel('beta'); ylabel('alpha'); %xlim([-1.4 1.4]); xticks([-1.5:0.5:1.5]);
% legend('P', 'Q');


%% Clarke transform 
% n_clarke = sqrt(2/3); % power invariant
% T_clarke = [1 -0.5 -0.5; 0 sqrt(3)/2 -sqrt(3)/2];
% T_inv = [2/3 0; -1/3 sqrt(3)/3; -1/3 -sqrt(3)/3];
% v_clarke = n_clarke * T_clarke * vabc_real;
% i_clarke = n_clarke * T_clarke * iabc_real;

%% Clarke + Fortescue 

%{
 q_op = exp(-1*j*pi/2);

v_orto = [ 0, 1; -1, 0] * v_clarke;

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
%}


% figure(1);
% subplot(2,1,1);
% plot(v_pos(2,:), v_pos(1,:)); hold on;
% plot(v_neg(2,:), v_neg(1,:), '--', 'LineWidth', 1.5);
% plot(v_alphabeta(2,:), v_alphabeta(1,:)); 
% hold off; grid on;
% legend;
% 
% subplot(2,1,2);
% plot(i_pos(2,:), i_pos(1,:)); hold on;
% plot(i_neg(2,:), i_neg(1,:), '--', 'LineWidth', 1.5);
% plot(i_alphabeta(2,:), i_alphabeta(1,:)); hold off; grid on;
% legend;

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
% all_vectors = [vabc, iabc, ip, iq, q]; % Concatenates all vectors
% max_limit = max(abs(all_vectors), [], 'all') * 1.1; % Find max value and add margin
% min_limit = -max_limit; % Make it symmetric

%% Animation Loop
%animation = 'ac';
%run('plots');