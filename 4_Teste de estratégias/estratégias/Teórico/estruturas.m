clear all;
% Ganhos das estratégias
estrategia = 'apoc';
run('escolha_pesos.m');
run('dados.m');
theta_pos = 0; theta_neg = 0;

pu = 0;

% Criar figura única e configurar o subplot para os gráficos
figure(1);
subplot(1,2,1);
xlabel('u'); ylabel('|q|');
hold on; % Para segurar todos os gráficos no mesmo subplot

% Definindo cores para as curvas
cores = {'b', 'g', 'm'}; % Cores para as curvas: azul, verde, magenta
legendInfo = cell(1, 3); % Prepara a variável para armazenar informações da legenda
legendPatches = cell(1,3);

for i = 1:3 
    % Calcular potências
    [pot_ativa{i}, pot_reativa{i}, vetor_u{i}] = calcular_potencias(Vabc_comp_pos, Vabc_comp_neg, ...
        P_ref(i), Q_ref(i), kp, kq, tempo, wn, theta_pos, theta_neg, pu);
    
    % Plotar potência reativa no mesmo subplot
    if (i == 2)
        plot(vetor_u{i}, pot_reativa{i}, 'Color', cores{i}, 'LineStyle', '--'); % Define a cor da curva
    else
        plot(vetor_u{i}, pot_reativa{i}, 'Color', cores{i});
    end

    % Ponto de destaque
    u_ponto = 2/11;
    plot(u_ponto, y_ponto_reativo(i), '*', 'Color', cores{i}, 'MarkerSize', 10); % Define a cor do ponto
    legendPatches{i} = patch([0 1], [0 0], cores{i}); % Cria um patch com a cor da curva
     %hold on;
    legendInfo{i} = sprintf('P_{ref} = %d, Q_{ref} = %d, * = %.3f', P_ref(i), Q_ref(i), y_ponto_reativo(i));
    % Adicionar legenda para cada curva
   
end

legend([legendPatches{:}], legendInfo, 'Location', 'northwest'); % Define a localização da legenda


% Gráficos de potência ativa no subplot 2
subplot(1,2,2);
xlabel('u'); ylabel('|p|');
hold on; % Para segurar todos os gráficos no mesmo subplot

% Definindo cores para as curvas
cores = {'b', 'g', 'm'}; % Cores para as curvas: azul, verde, magenta
legendInfo = cell(1, 3); % Prepara a variável para armazenar informações da legenda
legendPatches = cell(1,3);

for i = 1:3 
    if (i == 2)
        plot(vetor_u{i}, pot_ativa{i}, 'Color', cores{i}, 'LineStyle', '--'); % Define a cor da curva
    else
        plot(vetor_u{i}, pot_ativa{i}, 'Color', cores{i});
    end

    % Ponto de destaque
    plot(u_ponto, y_ponto_ativo(i), '*', 'Color', cores{i}, 'MarkerSize', 10); % Define a cor do ponto
    legendPatches{i} = patch([0 1], [0 0], cores{i}); % Cria um patch com a cor da curva
     %hold on;
    legendInfo{i} = sprintf('P_{ref} = %d, Q_{ref} = %d, * = %.3f', P_ref(i), Q_ref(i), y_ponto_ativo(i));
    % Adicionar legenda para cada curva
   
end

legend([legendPatches{:}], legendInfo, 'Location', 'northwest'); % Define a localização da legenda

