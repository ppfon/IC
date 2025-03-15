clear workspace;
% Escolha da estratégia
estrategia = 'pnsc';
run('escolha_pesos.m');
run('dados.m');
theta_pos = 0; theta_neg = 0;
clear('ylim', 'yticks');
pu = 0;

% Ponto de destaque
u_ponto = [0.1818; 0.3333; 0.5714];

% propriedades da figura

% Criar figura única e configurar o subplot para os gráficos
figure('Color', 'white');

%subplot(1,2,1);
tiledlayout(1,2, 'TileSpacing','Compact','Padding','Compact');
nexttile
xlabel('$u$','Interpreter','latex', 'FontWeight','bold', 'FontSize', 14); 
%ylabel('|q|  VAr', 'FontWeight','bold', 'FontSize', 12);
ylabel('$\vert \tilde{q} \vert \; VAr$','Interpreter','latex', 'FontWeight','bold', 'FontSize', 14);
hold on; grid on; 
ylim(limite_reativo); yticks(passo_reativo); 
xlim([0 0.6]); xticks(0:0.05:0.6) % Limites dos eixos
h = gca;
h.YAxis.FontSize = 14;
h.XAxis.FontSize = 14;
% h.YAxis.FontWeight = 'bold';
% h.XAxis.FontWeight = 'bold';

% Definindo cores para as curvas
cores = {'blue', 'r', 'black'}; % Cores para as curvas: azul, verde, magenta
legendInfo = cell(1, 3); % Prepara a variável para armazenar informações da legenda
legendPatches = cell(1,3);

for i = 1:3
    % Calcular potências
    [pot_ativa{i}, pot_reativa{i}, vetor_u{i}] = calcular_potencias(Vabc_comp_pos, Vabc_comp_neg, ...
        P_ref(i), Q_ref(i), kp, kq, tempo, wn, theta_pos, theta_neg, pu);

    % Plotar potência reativa no mesmo subplot
    if (i == 2 && strcmp(estrategia, 'bpsc'))
        plot(vetor_u{i}, pot_reativa{i}, 'Color', cores{i}, 'LineStyle', '--', 'LineWidth', 2);
    else
        plot(vetor_u{i}, pot_reativa{i}, 'Color', cores{i});
    end
    xlim([0 0.6]); % Define os limites do eixo x após o plot

    plot(u_ponto(1), y_ponto_reativo_1(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    plot(u_ponto(2), y_ponto_reativo_2(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    plot(u_ponto(3), y_ponto_reativo_3(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);

    erro_reativo(1,i) = 100 * (pot_reativa{i}(1820) - y_ponto_reativo_1(i)) / pot_reativa{i}(1820);
    erro_reativo(2,i) = 100 * (pot_reativa{i}(3335) - y_ponto_reativo_2(i)) / pot_reativa{i}(3335);
    erro_reativo(3,i) = 100 * (pot_reativa{i}(5716) - y_ponto_reativo_3(i)) / pot_reativa{i}(5716);

    xlim([0 0.6]); % Garante os limites do eixo x

end



% Gráficos de potência ativa no subplot 2
%subplot(1,2,2);
nexttile
xlabel('$u$','Interpreter','latex', 'FontSize', 14); ylabel('$\vert \tilde{p} \vert \; W$','Interpreter','latex', 'FontSize', 14);
hold on; grid on; 
ylim(limite_ativo); yticks(passo_ativo);
xlim([0 0.6]);
xticks([0:0.05:0.6]);% Define os limites do eixo x
h = gca;
h.YAxis.FontSize = 14;
h.XAxis.FontSize = 14;
% h.YAxis.FontWeight = 'bold';
% h.XAxis.FontWeight = 'bold';

% Definindo cores para as curvas
cores = {'b', 'r', 'k'};
legendInfo = cell(1, 3);
legendPatches = cell(1,3);

for i = 1:3
    if (i == 2 && strcmp(estrategia, 'bpsc'))
        plot(vetor_u{i}, pot_ativa{i}, 'Color', cores{i}, 'LineStyle', '--', 'LineWidth', 2);
    else
        plot(vetor_u{i}, pot_ativa{i}, 'Color', cores{i});
    end 
    xlim([0 0.6]); % Define os limites do eixo x após o plot

    plot(u_ponto(1), y_ponto_ativo_1(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    plot(u_ponto(2), y_ponto_ativo_2(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    plot(u_ponto(3), y_ponto_ativo_3(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);

    erro_ativo(1,i) = 100 * (pot_ativa{i}(1820) - y_ponto_ativo_1(i)) / pot_ativa{i}(1820);
    erro_ativo(2,i) = 100 * (pot_ativa{i}(3335) - y_ponto_ativo_2(i)) / pot_ativa{i}(3335);
    erro_ativo(3,i) = 100 * (pot_ativa{i}(5716) - y_ponto_ativo_3(i)) / pot_ativa{i}(5716);

    xlim([0 0.6]); % Garante os limites do eixo x
end

for i = 1:3
    legendPatches{i} = patch([0 1], [0 0], cores{i}); % Cria um patch com a cor da curva
    % if (p_factor(i) > 100)
    %     legendInfo{i} = sprintf('P_{ref} = %.2f     (%.2f) | Q_{ref} = %.2f (%.2f)', P_ref(i), ceil(p_factor(i)* 100)/100, Q_ref(i), ceil(q_factor(i)* 100)/100);
    % else if (q_factor(i) > 1) 
    %     legendInfo{i} = sprintf('P_{ref} = %.2f (%.2f) | Q_{ref} = %.2f     (%.2f)', P_ref(i), ceil(p_factor(i)* 100)/100, Q_ref(i), ceil(q_factor(i)* 100)/100);
    % else 
    %     legendInfo{i} = sprintf('P_{ref} = %.2f (%.2f) | Q_{ref} = %.2f (%.2f)', P_ref(i), ceil(p_factor(i)* 100)/100, Q_ref(i), ceil(q_factor(i)* 100)/100);
    % end 
    % end
    switch i
        case 1
            legendInfo{i} = sprintf('P_{ref} = %.2f     (%.2f) | Q_{ref} = %.2f (%.2f)', P_ref(i), ceil(p_factor(i)* 100)/100, Q_ref(i), ceil(q_factor(i)* 100)/100);
        case 2
            legendInfo{i} = sprintf('P_{ref} = %.2f   (%.2f) | Q_{ref} = %.2f     (%.2f)', P_ref(i), ceil(p_factor(i)* 100)/100, Q_ref(i), ceil(q_factor(i)* 100)/100);
        case 3
            legendInfo{i} = sprintf('P_{ref} = %.2f     (%.2f) | Q_{ref} = %.2f (%.2f)', P_ref(i), ceil(p_factor(i)* 100)/100, Q_ref(i), ceil(q_factor(i)* 100)/100);
            
    end
end
sgtitle(upper(estrategia), 'FontSize', 14);
legend([legendPatches{:}], legendInfo, 'Location', 'northwest', 'FontSize', 14);
