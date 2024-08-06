figure(1);

%%%%% Referencial original & transformacoes (+ potencia)
%%%%% invariantes em pot. e amp., respectivamente.

subplot(3,3,1);

fplot(i_abc_vetor, [0 2*periodo]);

legend('i_{a}', 'i_{b}', 'i_{c}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{a,b,c} [p.u]'});
title({'Correntes no referencial abc'});

subplot(3,3,4);

fplot(i_transf_pot_vetor, [0 2*periodo]);
legend('i_{0}', 'i_{\alpha}', 'i_{\beta}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i 0, \alpha, \beta [p.u]'});
title({'Transformaçao invariante em potencia'});


subplot(3,3,7);

fplot(i_transf_amp_vetor, [0 2*periodo]);
legend('i_{0}', 'i_{\alpha}', 'i_{\beta}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i 0, \alpha, \beta [p.u]'});
title({'Transformaçao invariante em amplitude'});

%%%%% Referencial original & transformacoes INVERSAS (+ potencia)
%%%%% invariantes em pot. e amp., respectivamente.
subplot(3,3,2);

fplot(i_abc_vetor, [0 2*periodo]); 
legend('i_{a}', 'i_{b}', 'i_{c}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{a,b,c} [p.u]'});
title({'Correntes no referencial abc'});

subplot(3,3,3)
fplot(pot_abc, [0 2*periodo]);
legend('pot_{abc}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'Potencia ativa instantanea [p.u]'});
ytickformat('%.4f')
title({'Potencia ativa instantanea no referencial abc'});

subplot(3,3,5);

fplot(i_transf_pot_vetor_inv, [0 2*periodo]); 
legend('i_{a}', 'i_{b}', 'i_{c}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{a,b,c} [p.u]'});
title({'Transformaçao inversa invariante em potencia'});

subplot(3,3,6);
fplot(pot_transf_inv, [0 2*periodo]); 
legend('pot_{abc}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'Potencia ativa instantanea [p.u]'});
ytickformat('%.4f')
title({'Potencia ativa instantanea da transf. inv. em potencia'});

subplot(3,3,8);

fplot(i_transf_amp_vetor_inv, [0 2*periodo]); 
legend('i_{a}', 'i_{b}', 'i_{c}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'i_{a,b,c} [p.u]'});
title({'Transformaçao inversa invariante em amplitude'});

subplot(3,3,9);
fplot(pot_transf_var, [0 2*periodo]); 
legend('pot_{abc}'); grid on;
xlabel({'Tempo [s]'}); ylabel({'Potencia ativa instantanea [p.u]'});
ytickformat('%.4f')
title({'Potencia ativa instantanea da transf. variante em potencia'});