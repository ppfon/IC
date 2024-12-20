function [pot_ativa, pot_reativa, vetor_u] = calcular_potencias(Vabc_comp_pos, Vabc_comp_neg, P_ref, Q_ref, kp, kq, tempo, wn, theta_pos, theta_neg, pu)
    % Inicializar potências e vetor de u
    pot_ativa = 0;
    pot_reativa = 0;
    vetor_u = 0;
    
    % Obter magnitude das componentes positiva e negativa
    mag_pos = abs(Vabc_comp_pos);
    mag_neg = abs(Vabc_comp_neg);
    
    % Calcular o ripple de potência ativa e reativa (apenas referência, pode ser ajustado)
    ripple_pot_ativa = P_ref * ( (kp + 1) .* mag_pos .* mag_neg .* cos(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (mag_pos.^2 + kp .* mag_neg.^2)  + ... 
                Q_ref * ( (1 - kq) .* mag_pos .* mag_neg .* sin(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (mag_pos.^2 + kq .* mag_neg.^2);

    ripple_pot_reativa = Q_ref * ( (1 + kq ) .* mag_pos .* mag_neg .* cos(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (mag_pos.^2 + kq .* mag_neg.^2)  - ... 
                P_ref * ( (1 - kp) .* mag_pos .* mag_neg .* sin(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (mag_pos.^2 + kp .* mag_neg.^2);
    
    % Laço para calcular as potências ativa e reativa para diferentes valores de u
    for u = 0:1/10000:0.7
        mag_pot_ativa = u .* sqrt( ...
                ((kp + 1) .* P_ref .* (1 ./ (1 + kp .* u.^2))).^2 + ...
                ((1 - kq) .* Q_ref .* (1 ./ (1 + kq .* u.^2))).^2 );

        mag_pot_reativa = u .* sqrt( ...
                 ((kq + 1) .* Q_ref .* (1 ./ (1 + kq .* u.^2))).^2 + ...
                 ((1 - kp) .* P_ref .* (1 ./ (1 + kp .* u.^2))).^2 );
    
        % Armazenar resultados
        pot_ativa = [pot_ativa mag_pot_ativa]; 
        pot_reativa  = [pot_reativa mag_pot_reativa]; 
        vetor_u = [vetor_u u];
    end

    if (pu == 1)
        pot_ativa = pot_ativa/P_ref;
        pot_reativa = pot_reativa/Q_ref;
    end

end
