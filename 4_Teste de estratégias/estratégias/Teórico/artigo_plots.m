clear workspace; clc; close all;

%% Frequency, characteristic angle, time vector
f = 1;  w = 2*pi*f; 
theta_c = 2*pi/3; a = exp(2*pi*j/3);
theta_i = pi/6;
t = linspace(0,1,100);

%% Voltages and currents
deseq_v = 0.4; deseq_i = 2;
amp_va = 1*deseq_v; amp_vb = 1*deseq_v; amp_vc = 1;
amp_ia = 1*deseq_i; amp_ib = 1*deseq_i; amp_ic = 1;

va = amp_va * exp(1j*(w*t)); %cos(w*t);
vb = amp_vb * exp(1*j*(w*t - theta_c));
vc = amp_vc * exp(1*j*(w*t - 2*theta_c));

ia = amp_ia * exp(1*j*(w*t + theta_i)); %cos(w*t - theta_i);
ib = amp_ib * exp(1*j*(w*t - theta_c + theta_i)); %cos(w*t - theta_c - theta_i);
ic = amp_ic * exp(1*j*(w*t - 2* theta_c + theta_i)); % cos(w*t - 2*theta_c - theta_i);

%% 3-phase arrays (3 x N)
v = [va; vb; vc];  % v(:,n) => [v_a(n); v_b(n); v_c(n)]
i = [ia; ib; ic];  % i(:,n) => [i_a(n); i_b(n); i_c(n)]
v_real = real(v); i_real = real(i);

%% Instantaneous active power p, reactive power vector q
% p = dot(v_real, i_real);      % 1 x N (dot product per column)
% q = cross(v_real, i_real);    % 3 x N (cross product per column)
% q_n = vecnorm(q);
p = dot(v_alphabeta, i_alphabeta);      % 1 x N (dot product per column)
q = cross(v_real, i_real);    % 3 x N (cross product per column)
q_n = vecnorm(q);

%% Compute ip and iq at each time step
% dot(v,v) is also 1 x N, so use elementwise division (./)
ip = (p .* v) ./ dot(v,v);      % 3 x N
iq = cross(q, v) ./ dot(v,v);   % 3 x N

%% Sequence components (Fortescue theorem) and voltage unbalaced factor
% T_seq = 1/3 *   [1,    1,    1;
%                  1,    a,   a^2;
%                  1,   a^2,   a];
% 
% v_seq = T_seq * v; v_pos = v_seq(2,:); v_neg = v_seq(3,:);
% u = mean(abs(v_neg)./abs(v_pos));
% i_seq = T_seq * i; i_pos = i_seq(2,:); i_neg = v_seq(3,:);

%% Clarke transform 
n_clarke = sqrt(2/3);
T_clarke = [1 -0.5 -0.5; 0 sqrt(3)/2 -sqrt(3)/2];
T_inv = [2/3 0; -1/3 sqrt(3)/3; -1/3 -sqrt(3)/3];
v_clarke = n_clarke * T_clarke * v_real;
i_clarke = n_clarke * T_clarke * i_real;

%% Clarke + Fortescue 
q_op = exp(-1*j*pi/2);

v_clarke_pos = 0.5 * [1, -q_op; q_op, 1] * v_clarke; % v_{alpha+,beta+}
v_clarke_neg = 0.5 * [1, q_op; -q_op, 1] * v_clarke; % v_{alpha-,beta-}
v_alpha = [v_clarke_pos(1,:) + v_clarke_neg(1,:)]; % v_{alpha} = v_{alpha+} + v_{alpha-}
v_beta = [v_clarke_neg(2,:) + v_clarke_neg(2,:)]; % v_{beta} = v_{beta+} + v_{beta-}
v_alphabeta = real([v_alpha; v_beta]); % v_{alpha,beta}
v_pos = v_clarke_pos; v_neg = v_clarke_neg;

i_clarke_pos = 0.5 * [1, -q_op; q_op, 1] * i_clarke; % i_{alpha+,beta+}
i_clarke_neg = 0.5 * [1, q_op; -q_op, 1] * i_clarke; % i_{alpha-,beta-}
i_alpha = [i_clarke_pos(1,:) + i_clarke_neg(1,:)]; % i_{alpha} = i_{alpha+} + i_{alpha-}
i_beta = [i_clarke_neg(2,:) + i_clarke_neg(2,:)]; % i_{beta} = i_{beta+} + i_{beta-}
i_alphabeta = real([i_alpha; i_beta]); % i_{alpha,beta}
i_pos = i_clarke_pos; i_neg = i_clarke_neg;


%% Figure 1: time-domain plot displaying one voltage and current cycle
% figure(1);
% subplot(2,1,1);
% plot(t, real(v));
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
set(gcf, 'WindowButtonDownFcn', @togglePause); % Detect mouse click

global isPaused;
isPaused = false; % Control variable for pausing

%% Determine Fixed Axis Limits
all_vectors = [v, i, ip, iq, q]; % Concatenates all vectors
max_limit = max(abs(all_vectors), [], 'all') * 1.1; % Find max value and add margin
min_limit = -max_limit; % Make it symmetric

%% Animation Loop
animation = 'ab';

if (strcmp(animation,'abc')) 
while 1
for n = 1:length(t)
    % Wait if paused
    while isPaused
        pause(0.1); % Small pause to avoid excessive CPU usage
    end
    
    cla;  
    hold on;
    
    % Plot voltage, current, ip, iq, and q at time index n
    quiver3(0,0,0, v_real(1,n),  v_real(2,n),  v_real(3,n),  'r','LineWidth',1.5);
    quiver3(0,0,0, i_real(1,n),  i_real(2,n),  i_real(3,n),  'b','LineWidth',1.5);
    quiver3(0,0,0, ip(1,n), ip(2,n), ip(3,n), 'g','LineWidth',1.5);
    quiver3(0,0,0, iq(1,n), iq(2,n), iq(3,n), 'm','LineWidth',1.5);
    quiver3(0,0,0, q(1,n),  q(2,n),  q(3,n),  'k','LineWidth',1.5);
    quiver3(0,0,0,0,0,p(1,n),'y','LineWidth',1.5);
    quiver3(0,0,0,0,0,q_n(1,n),'c','LineWidth',1.5);
    

legend({...
    sprintf('v (%.2f, %.2f, %.2f)', v_real(1,n), v_real(2,n), v_real(3,n)), ...
    sprintf('i (%.2f, %.2f, %.2f)', i_real(1,n), i_real(2,n), i_real(3,n)), ...
    sprintf('i_p (%.2f, %.2f, %.2f)', ip(1,n), ip(2,n), ip(3,n)), ...
    sprintf('i_q (%.2f, %.2f, %.2f)', iq(1,n), iq(2,n), iq(3,n)), ...
    sprintf('q (%.2f, %.2f, %.2f)', q(1,n), q(2,n), q(3,n)), ...
    sprintf('p (%.2f)', p(1,n)), ...
    sprintf('|q| (%.2f)', q_n(1,n)) ...
}, 'Location', 'best');

    xlabel('b'); ylabel('a'); zlabel('c');
    %legend('v','i','i_p','i_q','q', 'p','|q|', 'Location','best');


    axis equal; % Keep aspect ratio uniform
    xlim([min_limit max_limit]);
    ylim([min_limit max_limit]);
    zlim([min_limit max_limit]);
    
    grid on;
    hold off;
    
    drawnow;     % Force MATLAB to update the figure
    pause(0.05); % Small pause for animation speed
end
end
end

%% Function to toggle pause state on right-click
function togglePause(~, event)
    global isPaused;
    if strcmp(event.Source.SelectionType, 'alt') % Right-click detected
        isPaused = ~isPaused; % Toggle pause state
    end
end