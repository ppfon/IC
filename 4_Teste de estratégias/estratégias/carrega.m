clear workspace;
freq_amostragem = 9e3; periodo_amostragem = 1/freq_amostragem;

% le_pnsc_57_p0_a = load("Novos dados/pnsc/0.5714/q1500p0/ativo/stgy.mat", "stgy");
% pnsc_57_p0_a = le_pnsc_57_p0_a.stgy(:,2);
% 
% le_pnsc_33_p0_a = load("Novos dados/pnsc/0.3333/q1500p0/ativo/stgy.mat", "stgy");
% pnsc_33_p0_a = le_pnsc_33_p0_a.stgy(:,2);
% 
% le_pnsc_18_p0_a = load("Novos dados/pnsc/0.1818/q1500p0/ativo/stgy.mat", "stgy");
% pnsc_18_p0_a = le_pnsc_18_p0_a.stgy(:,2);

le_pnsc_57_p0_a = readmatrix("Novos dados/pnsc/0.5714/q1500p0/pot_ativa.csv");
pnsc_57_p0_a = le_pnsc_57_p0_a(:,2);

le_pnsc_33_p0_a = readmatrix("Novos dados/pnsc/0.3333/q1500p0/pot_ativa.csv");
pnsc_33_p0_a = le_pnsc_33_p0_a(:,2);

le_pnsc_18_p0_a = readmatrix("Novos dados/pnsc/0.1818/q1500p0/pot_ativa.csv");
pnsc_18_p0_a = le_pnsc_18_p0_a(:,2);