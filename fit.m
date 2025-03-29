u_points = [0.1818, 0.1818, 0.1818, 0.3333, 0.3333, 0.3333, 0.5714, 0.5714, 0.5714];
p_ripple_magnitudes = [549.663, 35.6034, 361.179, 1107.3, 79.2032, 746.608, 2767.05, 278.044, 1828.76];
p_ref_values = [15.5962, 1504.08, 1002.15, 15.5334, 1501.31, 998.026, 3.04409, 1499.48, 999.664];

u_set1 = u_points(1:3);
p_ripple_set1 = p_ripple_magnitudes(1:3);
p_ref_set1 = p_ref_values(1:3);

u_set2 = u_points(4:6);
p_ripple_set2 = p_ripple_magnitudes(4:6);
p_ref_set2 = p_ref_values(4:6);

u_set3 = u_points(7:9);
p_ripple_set3 = p_ripple_magnitudes(7:9);
p_ref_set3 = p_ref_values(7:9);

model_func = @(P_ref, u) (2*u ./ (1 + u.^2)) * P_ref;

initial_guess = 1000;

fitted_P_ref1 = lsqcurvefit(model_func, initial_guess, u_set1, p_ripple_set1);
fprintf('Fitted P_ref for set 1: %.2f\n', fitted_P_ref1);

fitted_P_ref2 = lsqcurvefit(model_func, initial_guess, u_set2, p_ripple_set2);
fprintf('Fitted P_ref for set 2: %.2f\n', fitted_P_ref2);

fitted_P_ref3 = lsqcurvefit(model_func, initial_guess, u_set3, p_ripple_set3);
fprintf('Fitted P_ref for set 3: %.2f\n', fitted_P_ref3);

u_plot = linspace(min(u_points), max(u_points), 100);

fitted_p_ripple1 = model_func(fitted_P_ref1, u_plot);
fitted_p_ripple2 = model_func(fitted_P_ref2, u_plot);
fitted_p_ripple3 = model_func(fitted_P_ref3, u_plot);

plot(u_set1, p_ripple_set1, 'o', 'DisplayName', 'Set 1 Data');
hold on;
plot(u_plot, fitted_p_ripple1, '-', 'DisplayName', 'Set 1 Fitted Curve');

plot(u_set2, p_ripple_set2, 'o', 'DisplayName', 'Set 2 Data');
plot(u_plot, fitted_p_ripple2, '-', 'DisplayName', 'Set 2 Fitted Curve');

plot(u_set3, p_ripple_set3, 'o', 'DisplayName', 'Set 3 Data');
plot(u_plot, fitted_p_ripple3, '-', 'DisplayName', 'Set 3 Fitted Curve');

xlabel('u');
ylabel('|\tilde{p}|');
legend('show');
grid on;