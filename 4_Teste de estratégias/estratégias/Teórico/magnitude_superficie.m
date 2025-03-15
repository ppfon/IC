% [Q_ref, kp] = meshgrid(0:0.1:1, -1:0.2:1); % Create grid for Q_ref and kp
% P_ref = sqrt(1 - Q_ref.^2);
[Q_ref, kp] = meshgrid(linspace(0, 1, 50), linspace(-1, 1, 50)); % Reverse Q_ref ordering
P_ref = sqrt(1 - Q_ref.^2); % Compute P_ref

% Everything else remains the same

u_values = [2/11, 1/3, 0.5714]; % Different u values for different slices

figure(1);
hold on;
for u = u_values
    mag_pot_ativa = u .* sqrt( ...
        ((kp + 1) .* P_ref .* (1 ./ (1 + kp .* u.^2))).^2 + ...
        ((1 - kp) .* Q_ref .* (1 ./ (1 + kp .* u.^2))).^2 );


    surf(P_ref, kp, mag_pot_ativa, 'FaceAlpha', 0.5); % Plot surfaces
colormap(parula) % Try different colormaps (parula, jet, etc.)
shading interp % Smoothens color transitions
lighting phong % Enhances depth perception
%camlight headlight % Adds directional lighting
alpha(1) % Ensures solid color with no transparency

end

ylabel("k_p = k_q");
xlabel("P* = sqrt(1-Q*^2)");
zlabel("|p̃| (pu)"); zticks([0:0.5:1.5]);
grid on;
view(3); % Set 3D view
hold off;

figure(2);
hold on;
for u = u_values
mag_pot_reativa = u .* sqrt( ...
    ((kp + 1) .* Q_ref .* (1 ./ (1 + kp .* u.^2))).^2 + ...
    ((1 - kp) .* P_ref .* (1 ./ (1 + kp .* u.^2))).^2 );

    surf(Q_ref, kp, mag_pot_reativa, 'FaceAlpha', 0.5); % Plot surfaces
end

ylabel("k_p = k_q");
xlabel("Q* = sqrt(1-P*^2)");
zlabel("|q̃| (pu)"); zticks([0:0.5:1.5]);
grid on;
view(3); % Set 3D view
hold off;
