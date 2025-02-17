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
    quiver3(0,0,0, vabc_real(1,n),  vabc_real(2,n),  vabc_real(3,n),  'r','LineWidth',1.5);
    quiver3(0,0,0, iabc_real(1,n),  iabc_real(2,n),  iabc_real(3,n),  'b','LineWidth',1.5);
    quiver3(0,0,0, ip(1,n), ip(2,n), ip(3,n), 'g','LineWidth',1.5);
    quiver3(0,0,0, iq(1,n), iq(2,n), iq(3,n), 'm','LineWidth',1.5);
    quiver3(0,0,0, q(1,n),  q(2,n),  q(3,n),  'k','LineWidth',1.5);
    quiver3(0,0,0,0,0,p(1,n),'y','LineWidth',1.5);
    quiver3(0,0,0,0,0,q_n(1,n),'c','LineWidth',1.5);
    

legend({...
    sprintf('v (%.2f, %.2f, %.2f)', vabc_real(1,n), vabc_real(2,n), vabc_real(3,n)), ...
    sprintf('i (%.2f, %.2f, %.2f)', iabc_real(1,n), iabc_real(2,n), iabc_real(3,n)), ...
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