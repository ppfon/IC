clear workspace; clc; close all;

%% Frequency, characteristic angle, time vector
f = 1;  w = 2*pi*f; 
theta_c = 2*pi/3; a = exp(2*pi*j/3);
theta_i = pi/6;
t = linspace(0,1,100);

%% Voltages and currents
deseq_v = 1; deseq_i = 1;
amp_va = 2*deseq_v; amp_vb = 2*deseq_v; amp_vc = 2;
amp_ia = 1*deseq_i; amp_ib = 1*deseq_i; amp_ic = 1*deseq_i;

va = amp_va * cos(w*t);
vb = amp_vb * cos(w*t - theta_c);
vc = amp_vc * cos(w*t - 2*theta_c);

ia = amp_ia * cos(w*t + theta_i); 
ib = amp_ib * cos(w*t - theta_c + 1*theta_i);
ic = amp_ic * cos(w*t - 2*theta_c + theta_i);

%% 3-phase arrays (3 x N)
v = [va; vb; vc];  % v(:,n) => [v_a(n); v_b(n); v_c(n)]
i = [ia; ib; ic];  % i(:,n) => [i_a(n); i_b(n); i_c(n)]

%% Instantaneous active power p, reactive power vector q
p = dot(v, i);      % 1 x N (dot product per column)
q = cross(v, i);    % 3 x N (cross product per column)
% Norm of q (optional; not used in the animation)
q_n = vecnorm(q);

%% Compute ip and iq at each time step
% dot(v,v) is also 1 x N, so use elementwise division (./)
ip = (p .* v) ./ dot(v,v);      % 3 x N
iq = cross(q, v) ./ dot(v,v);   % 3 x N

% T_clarke = sqrt(2/3) * [1 0; 1/sqrt(3) 2/sqrt(3)];
% T_seq = 1/3 *   [1,    1,    1;
%                  1,    a,   a^2;
%                  1,   a^2,   a];
% 
% v_seq = T_seq * v; v_pos = v_seq(2,:); v_neg = v_seq(3,:);
% u = mean(abs(v_neg)./abs(v_pos));

%% Figure 1: time-domain plot displaying one voltage and current cycle
% figure(1);
% subplot(2,1,1);
% plot(t, v);
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
figure(2);
set(gcf, 'WindowButtonDownFcn', @togglePause); % Detect mouse click

global isPaused;
isPaused = false; % Control variable for pausing

%% Determine Fixed Axis Limits
all_vectors = [v, i, ip, iq, q]; % Concatenates all vectors
max_limit = max(abs(all_vectors), [], 'all') * 1.1; % Find max value and add margin
min_limit = -max_limit; % Make it symmetric

%% Animation Loop
animation = 'abc';

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
    quiver3(0,0,0, v(1,n),  v(2,n),  v(3,n),  'r','LineWidth',1.5);
    quiver3(0,0,0, i(1,n),  i(2,n),  i(3,n),  'b','LineWidth',1.5);
    quiver3(0,0,0, ip(1,n), ip(2,n), ip(3,n), 'g','LineWidth',1.5);
    quiver3(0,0,0, iq(1,n), iq(2,n), iq(3,n), 'm','LineWidth',1.5);
    quiver3(0,0,0, q(1,n),  q(2,n),  q(3,n),  'k','LineWidth',1.5);
    quiver3(0,0,0,0,0,p(1,n),'y','LineWidth',1.5);
    quiver3(0,0,0,0,0,q_n(1,n),'c','LineWidth',1.5);

legend({...
    sprintf('v (%.2f, %.2f, %.2f)', v(1,n), v(2,n), v(3,n)), ...
    sprintf('i (%.2f, %.2f, %.2f)', i(1,n), i(2,n), i(3,n)), ...
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