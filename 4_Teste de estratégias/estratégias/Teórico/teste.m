clear all;

estrategias = {'aarc', 'bpsc', 'pnsc', 'apoc', 'rpoc'};
num_estrategias = length(estrategias);

% Inicializar vetores para armazenar os dados
vetor_u_total = [];
pot_ativa_total = [];
pot_reativa_total = [];
estrategia_indice = [];
ref_indice_P = [];
ref_indice_Q = [];

% Loop para cada estratégia
for i = 1:num_estrategias
    estrategia = estrategias{i};
    run('escolha_pesos.m');
    run('dados.m'); 
    theta_pos = 0; theta_neg = 0;
    pu = 0; 

    % Loop para cada conjunto de P_ref e Q_ref
    for j = 1:length(P_ref)
        % Calcular potências 
        [pot_ativa, pot_reativa, vetor_u] = calcular_potencias(Vabc_comp_pos, Vabc_comp_neg, ...
            P_ref(j), Q_ref(j), kp, kq, tempo, wn, theta_pos, theta_neg, pu);

        % Armazenar os dados
        vetor_u_total = [vetor_u_total vetor_u];
        pot_ativa_total = [pot_ativa_total pot_ativa];
        pot_reativa_total = [pot_reativa_total pot_reativa];
        estrategia_indice = [estrategia_indice i*ones(1,length(vetor_u))]; 
        ref_indice_P = [ref_indice_P j*ones(1,length(vetor_u))];
        ref_indice_Q = [ref_indice_Q j*ones(1,length(vetor_u))];
    end
end

% Adicionar pequeno valor aleatório para garantir pontos únicos
rng('shuffle'); 
vetor_u_total = vetor_u_total + rand(size(vetor_u_total))*1e-6;
estrategia_indice = estrategia_indice + rand(size(estrategia_indice))*1e-6;
ref_indice_P = ref_indice_P + rand(size(ref_indice_P))*1e-6;
ref_indice_Q = ref_indice_Q + rand(size(ref_indice_Q))*1e-6;

% Ordenar os pontos para potência ativa
dados_P = [vetor_u_total' estrategia_indice' ref_indice_P'];
dados_ordenados_P = sortrows(dados_P);
vetor_u_total_P = dados_ordenados_P(:,1)';
estrategia_indice_P = dados_ordenados_P(:,2)';
ref_indice_P = dados_ordenados_P(:,3)';

% Ordenar os pontos para potência reativa
dados_Q = [vetor_u_total' estrategia_indice' ref_indice_Q'];
dados_ordenados_Q = sortrows(dados_Q);
vetor_u_total_Q = dados_ordenados_Q(:,1)';
estrategia_indice_Q = dados_ordenados_Q(:,2)';
ref_indice_Q = dados_ordenados_Q(:,3)';

% Criar a malha para potência ativa
[X_P,Y_P,Z_P] = meshgrid(sort(vetor_u_total_P), sort(estrategia_indice_P), sort(ref_indice_P));

% Criar a malha para potência reativa
[X_Q,Y_Q,Z_Q] = meshgrid(sort(vetor_u_total_Q), sort(estrategia_indice_Q), sort(ref_indice_Q));

% Interpolação da potência ativa
V_ativo = griddata(vetor_u_total_P, estrategia_indice_P, ref_indice_P, pot_ativa_total, X_P, Y_P, Z_P);

% Interpolação da potência reativa
V_reativo = griddata(vetor_u_total_Q, estrategia_indice_Q, ref_indice_Q, pot_reativa_total, X_Q, Y_Q, Z_Q);

% Plotar os gráficos 3D
figure;

subplot(1,2,1);
slice(X_P, Y_P, Z_P, V_ativo, [], 1:num_estrategias, []);
xlabel('u');
ylabel('Estratégia');
zlabel('P_{ref}');
title('Potência Ativa');
xticks(0:0.1:0.7);
yticks(1:num_estrategias);
yticklabels(estrategias);
zticks(1:length(P_ref));
colorbar;

subplot(1,2,2);
slice(X_Q, Y_Q, Z_Q, V_reativo, [], 1:num_estrategias, []);
xlabel('u');
ylabel('Estratégia');
zlabel('Q_{ref}');
title('Potência Reativa');
xticks(0:0.1:0.7);
yticks(1:num_estrategias);
yticklabels(estrategias);
zticks(1:length(Q_ref));
colorbar;