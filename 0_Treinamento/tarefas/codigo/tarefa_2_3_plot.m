figure(1);

%%%%% LETRA A -> p = 0; theta = 0 %%%%%
subplot(2,4,1)

fplot(i_abc_a, [0 2*periodo]);
legend('i_{a}', 'i_{b}', 'i_{c}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{a,b,c} [p.u]'}); ylim([-2, 2]);
title({'i_{abc} | (\rho = 0; \theta = 0)'});

subplot(2,4,5)

fplot(i_0dq_a, [0 2*periodo]);
legend('i_{0}', 'i_{d}', 'i_{q}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{0,d,q} [p.u]'}); ylim([-1.5, 1.5]);
title({'Transformaçao 0dq invariante em amplitude'});


%%%%% LETRA B -> p = omega*t; theta = 0 %%%%%
subplot(2,4,2)

fplot(i_abc_b, [0 2*periodo]);
legend('i_{a}', 'i_{b}', 'i_{c}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{a,b,c} [p.u]'}); ylim([-2, 2]);
title({'i_{abc} | (\rho = \omega \cdot t; \theta = 0º)'});

subplot(2,4,6)

fplot(i_0dq_b, [0 2*periodo]);
legend('i_{0}', 'i_{d}', 'i_{q}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{0,d,q} [p.u]'}); ylim([-0.5, 1.5]);
title({'Transformaçao 0dq invariante em amplitude'});

%%%%% LETRA C -> p = omega*t; theta = 50 %%%%%
subplot(2,4,3)

fplot(i_abc_c, [0 2*periodo]);
legend('i_{a}', 'i_{b}', 'i_{c}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{a,b,c} [p.u]'}); ylim([-2, 2]);
title({'i_{abc} | (\rho = \omega \cdot t; \theta = 50º)'});

subplot(2,4,7)

fplot(i_0dq_c, [0 2*periodo]);
legend('i_{0}', 'i_{d}', 'i_{q}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{0,d,q} [p.u]'}); ylim([-0.5, 1.5]);
title({'Transformaçao 0dq invariante em amplitude'}); 


%%%%% LETRA D -> p = -omega*t; theta = 0 %%%%%
subplot(2,4,4)

fplot(i_abc_d, [0 2*periodo]);
legend('i_{a}', 'i_{b}', 'i_{c}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{a,b,c} [p.u]'}); ylim([-2, 2]);
title({'i_{abc} | (\rho = -\omega \cdot t; \theta = 0º)'});

subplot(2,4,8)

fplot(i_0dq_d, [0 2*periodo]);
legend('i_{0}', 'i_{d}', 'i_{q}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{0,d,q} [p.u]'}); ylim([-1.5, 1.5]);
title({'Transformaçao 0dq invariante em amplitude'});
