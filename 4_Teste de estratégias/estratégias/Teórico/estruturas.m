clear workspace;
% Escolha da estratégia
estrategia = 'bpsc';
run('escolha_pesos.m');
run('dados.m');
theta_pos = 0; theta_neg = 0;
clear('ylim', 'yticks');
pu = 0;

% Criar figura única e configurar o subplot para os gráficos
figure(1);
subplot(1,2,1);
xlabel('u','FontWeight', 'bold'); ylabel('|q| var','FontWeight', 'bold');
hold on; grid on; 
ylim(limite_reativo); yticks(passo_reativo); 
xlim([0 0.6]); xticks([0:0.05:0.6]) % Limites dos eixos

% Definindo cores para as curvas
cores = {'b', 'r', 'k'}; % Cores para as curvas: azul, verde, magenta
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

    % Ponto de destaque
    u_ponto_1 = 0.1818;
    u_ponto_2 = 1/3;
    u_ponto_3 = 0.5714;

    plot(u_ponto_1, y_ponto_reativo_1(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    plot(u_ponto_2, y_ponto_reativo_2(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    plot(u_ponto_3, y_ponto_reativo_3(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    xlim([0 0.6]); % Garante os limites do eixo x

    legendPatches{i} = patch([0 1], [0 0], cores{i}); % Cria um patch com a cor da curva
    legendInfo{i} = sprintf('P_{ref} = %d, Q_{ref} = %d', P_ref(i), Q_ref(i));
end

legend([legendPatches{:}], legendInfo, 'Location', 'northwest'); % Define a localização da legenda

% Gráficos de potência ativa no subplot 2
subplot(1,2,2);
xlabel('u'); ylabel('|p| W');
hold on; grid on; 
ylim(limite_ativo); yticks(passo_ativo);
xlim([0 0.6]); %xticks([0 0.1 0.1818 0.3333 0.4 0.5714])
xticks([0:0.05:0.6])% Define os limites do eixo x

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

    % Ponto de destaque
    u_ponto_1 = 0.1818;
    u_ponto_2 = 1/3;
    u_ponto_3 = 0.5714;

    plot(u_ponto_1, y_ponto_ativo_1(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    plot(u_ponto_2, y_ponto_ativo_2(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    plot(u_ponto_3, y_ponto_ativo_3(i), 'o', 'Color', cores{i}, 'MarkerSize', 6);
    xlim([0 0.6]); % Garante os limites do eixo x

    legendPatches{i} = patch([0 1], [0 0], cores{i});
    legendInfo{i} = sprintf('P_{ref} = %d, Q_{ref} = %d', P_ref(i), Q_ref(i));
end

switch (u_ponto_1)
    case 0.1818
        ponto = 1820;
    case 1/3
        ponto = 3335;
    case 0.5714
        ponto = 5716;
end

resultado_ativa = cellfun(@(x) x(ponto), pot_ativa);
resultado_reativa = cellfun(@(x) x(ponto), pot_reativa);

legend([legendPatches{:}], legendInfo, 'Location', 'northwest');
