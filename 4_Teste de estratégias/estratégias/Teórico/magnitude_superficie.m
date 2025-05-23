% [Q_ref, kp] = meshgrid(0:0.1:1, -1:0.2:1); % Create grid for Q_ref and kp
% P_ref = sqrt(1 - Q_ref.^2);
[Q_ref, kp] = meshgrid(linspace(0, 1, 50), linspace(-1, 1, 50)); % Reverse Q_ref ordering
P_ref = sqrt(1 - Q_ref.^2); % Compute P_ref
set(gcf,'color','white');

% Everything else remains the same

u_values = [2/11, 1/3, 0.5714]; % Different u values for different slices

figure(1);
tiledlayout(1,2, 'TileSpacing','Compact','Padding','Compact');
nexttile
h = gca; h.YAxis.FontSize = 24; h.XAxis.FontSize = 24;h.GridLineWidth = 3;
hold on;

for u = u_values
    mag_pot_ativa = u .* sqrt( ...
        ((kp + 1) .* P_ref .* (1 ./ (1 + kp .* u.^2))).^2 + ...
        ((1 - kp) .* Q_ref .* (1 ./ (1 + kp .* u.^2))).^2 );

    surf(P_ref, kp, mag_pot_ativa, 'FaceAlpha', 0.5); % Plot surfaces
    lighting phong % Enhances depth perception
    alpha(1) % Ensures solid color with no transparency
    %colorbar;
end

% Draw opaque planes at k_p = -1, 0, and 1
y_min = min(Q_ref(:)); y_max = max(Q_ref(:)); z_min = min(mag_pot_ativa(:)); z_max = max(mag_pot_ativa(:));
kp_values = [-1, 0, 1]; plane_colors = [210/255, 105/255, 30/255]; % Blue, Red, Green

for i = 1:length(kp_values)
    kp_plane = kp_values(i);
    fill3([y_min y_max y_max y_min], [kp_plane kp_plane kp_plane kp_plane], [z_min z_min z_max z_max], ...
          plane_colors, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
end

ylabel("$k_{p} = k_{q}$", 'Interpreter','latex', 'FontSize', 24);
xlabel("$P^* = \sqrt{1-{Q^*}^2}$", 'Interpreter','latex', 'FontSize', 24);
zlabel("$\vert \tilde{p} \vert \; \mathrm{pu}$", 'Interpreter','latex', 'FontSize', 24); 
zticks(0:0.5:1.5);
grid on;
view(3); % Set 3D view
hold off;

%figure(2);
nexttile
h = gca; h.YAxis.FontSize = 24; h.XAxis.FontSize = 24;h.GridLineWidth = 3;

hold on;
for u = u_values
    mag_pot_reativa = u .* sqrt( ...
        ((kp + 1) .* Q_ref .* (1 ./ (1 + kp .* u.^2))).^2 + ...
        ((1 - kp) .* P_ref .* (1 ./ (1 + kp .* u.^2))).^2 );

    surf(Q_ref, kp, mag_pot_reativa, 'FaceAlpha', 0.5); % Plot surfaces
    lighting phong % Enhances depth perception
    alpha(1) % Ensures solid color with no transparency
    %colorbar;
end

% Draw opaque planes at k_p = -1, 0, and 1
z_min = min(mag_pot_reativa(:));
z_max = max(mag_pot_reativa(:));

for i = 1:length(kp_values)
    kp_plane = kp_values(i);
    %fill3([kp_plane kp_plane kp_plane kp_plane], [y_min y_max y_max y_min], [z_min z_min z_max z_max], ...
    fill3([y_min y_max y_max y_min], [kp_plane kp_plane kp_plane kp_plane], [z_min z_min z_max z_max], ...
          plane_colors, 'FaceAlpha', 0.5, 'EdgeColor', 'none');
end
h = gca; h.YAxis.FontSize = 24; h.XAxis.FontSize = 24;h.GridLineWidth = 3;

ylabel("$k_{p} = k_{q}$", 'Interpreter','latex', 'FontSize', 24);
xlabel("$Q^* = \sqrt{1-{P^*}^2}$", 'Interpreter','latex', 'FontSize', 24);
zlabel("$\vert \tilde{q} \vert \; \mathrm{pu}$", 'Interpreter','latex', 'FontSize', 24); 
zticks(0:0.5:1.5);
grid on;
view(3); % Set 3D view
hold off;
