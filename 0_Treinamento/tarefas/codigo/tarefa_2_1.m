clear global;
syms t i_c_pico;

omega = 377; % freq. angular
periodo = 2*pi/omega; % freq.
theta_carac = 2*pi/3; % angulo caracteristico do sistema
norm = 2/3; 

i_a_pico = 1; % 1 pu
i_b_pico = i_a_pico;

i_a_fasor = i_a_pico * cos(omega*t);
i_b_fasor = i_b_pico * cos(omega*t - theta_carac);
i_c_fasor = i_c_pico * cos(omega*t - 2*theta_carac);

i_fasor_espacial = norm * (i_a_fasor * exp(1j*0*theta_carac) ...
                         + i_b_fasor * exp(1j*1*theta_carac) ...
                         + i_c_fasor * exp(1j*2*theta_carac) ...
                         );

i_fasor_espacial_equi = subs(i_fasor_espacial, i_c_pico, 1);
i_fasor_espacial_desequi = subs(i_fasor_espacial, i_c_pico, 0.5);

figure(1);

subplot(1,2,1);
fplot(real(i_fasor_espacial_equi), imag(i_fasor_espacial_equi), [0 periodo]);

ylim([-1.5 1.5]); xlim([-1.25 1.25]); title("I_{a} = I_{b} = I_{c} = 1 [p.u]");
ylabel("Im(i-fasor-espacial)"); xlabel("Re(i-fasor-espacial)");

subplot(1,2,2);
fplot(real(i_fasor_espacial_desequi), imag(i_fasor_espacial_desequi), [0 periodo]);

ylim([-1.5 1.5]); xlim([-1.25 1.25]); title("I_{a} = I_{b} =  1 [p.u] | I_{c} = 0.5 [p.u]");
ylabel("Im(i-fasor-especial)"); xlabel("Re(i-fasor-espacial)");