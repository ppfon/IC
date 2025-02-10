clear workspace;
% Escolha da estratégia
estrategia = 'pnsc';
run('escolha_pesos.m');
run('dados.m');
theta_pos = 0; theta_neg = 0;

pu = 0;

% Criar figura única e configurar o subplot para os gráficos
figure(1);
subplot(1,2,1);
xlabel('u'); ylabel('|q|');
hold on; grid on; xlim = [0 0.6]; % Para segurar todos os gráficos no mesmo subplot

% Definindo cores para as curvas
cores = {'b', 'g', 'm'}; % Cores para as curvas: azul, verde, magenta
legendInfo = cell(1, 3); % Prepara a variável para armazenar informações da legenda
legendPatches = cell(1,3);

for i = 1:3
    % Calcular potências
    [pot_ativa{i}, pot_reativa{i}, vetor_u{i}] = calcular_potencias(Vabc_comp_pos, Vabc_comp_neg, ...
        P_ref(i), Q_ref(i), kp, kq, tempo, wn, theta_pos, theta_neg, pu);

    % Plotar potência reativa no mesmo subplot
    if (i == 2 && strcmp(estrategia, 'bpsc'))
        plot(vetor_u{i}, pot_reativa{i}, 'Color', cores{i}, 'LineStyle', '--'); xlim = [0 0.6]; % Define a cor da curva
    else
        plot(vetor_u{i}, pot_reativa{i}, 'Color', cores{i}); xlim = [0 0.6];
    end

    % Ponto de destaque
    u_ponto_1 = 0.1818;
    u_ponto_2 = 1/3;
    u_ponto_3 = 0.5714;

   plot(u_ponto_1, y_ponto_reativo_1(i), '*', 'Color', cores{i}, 'MarkerSize', 10); xlim = [0 0.6];
   plot(u_ponto_2, y_ponto_reativo_2(i), '*', 'Color', cores{i}, 'MarkerSize', 10); xlim = [0 0.6];
   plot(u_ponto_3, y_ponto_reativo_3(i), '*', 'Color', cores{i}, 'MarkerSize', 10); xlim = [0 0.6];


    legendPatches{i} = patch([0 1], [0 0], cores{i}); % Cria um patch com a cor da curva

    legendInfo{i} = sprintf('P_{ref} = %d, Q_{ref} = %d', P_ref(i), Q_ref(i));

end

legend([legendPatches{:}], legendInfo, 'Location', 'northwest'); % Define a localização da legenda


% Gráficos de potência ativa no subplot 2
subplot(1,2,2);
xlabel('u'); ylabel('|p|');
hold on; grid on; % Para segurar todos os gráficos no mesmo subplot

% Definindo cores para as curvas
cores = {'b', 'g', 'm'}; % Cores para as curvas: azul, verde, magenta
legendInfo = cell(1, 3); % Prepara a variável para armazenar informações da legenda
legendPatches = cell(1,3);

for i = 1:3
    if (i == 2)
        plot(vetor_u{i}, pot_ativa{i}, 'Color', cores{i}, 'LineStyle', '--'); xlim = [0 0.6]; % Define a cor da curva
    else
        plot(vetor_u{i}, pot_ativa{i}, 'Color', cores{i}); xlim = [0 0.6];
    end


    % Ponto de destaque
    u_ponto_1 = 0.1818;
    u_ponto_2 = 1/3;
    u_ponto_3 = 0.5714;

   plot(u_ponto_1, y_ponto_ativo_1(i), '*', 'Color', cores{i}, 'MarkerSize', 10); xlim = [0 0.6];
   plot(u_ponto_2, y_ponto_ativo_2(i), '*', 'Color', cores{i}, 'MarkerSize', 10); xlim = [0 0.6];
   plot(u_ponto_3, y_ponto_ativo_3(i), '*', 'Color', cores{i}, 'MarkerSize', 10); xlim = [0 0.6];

    legendPatches{i} = patch([0 1], [0 0], cores{i}); % Cria um patch com a cor da curva

    legendInfo{i} = sprintf('P_{ref} = %d, Q_{ref} = %d', P_ref(i), Q_ref(i));
    % Adicionar legenda para cada curva


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

% for k = 1:3
%    erro_ativa(k) = 100 * (resultado_ativa(k) - y_ponto_ativo(k))/resultado_ativa(k);
%    erro_reativa(k) = 100 * (resultado_reativa(k) - y_ponto_reativo(k))/resultado_reativa(k);
% end

legend([legendPatches{:}], legendInfo, 'Location', 'northwest'); % Define a localização da legenda
