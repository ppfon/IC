syms resistor_amortecimento

capacitor_filtro_calc = 31.1744e-6;
indutancia_rede_calc = 406.2677e-6;
indutancia_filtro_calc = indutancia_rede_calc;
resistencia_indutancia_rede = 3.8290e-3;
resistencia_indutancia_filtro = resistencia_indutancia_rede;

%%% CONSIDERANDO APENAS O RESISTOR DE AMORTECIMENTO, SEM RESISTENCIA DOS
%%% INDUTORES
num_1 = [capacitor_filtro_calc * resistor_amortecimento, 1];

deno_1 = [capacitor_filtro_calc * indutancia_filtro_calc * indutancia_rede_calc, ...
    (indutancia_rede_calc + indutancia_filtro_calc) * resistor_amortecimento * capacitor_filtro_calc, ...
    indutancia_rede_calc + indutancia_filtro_calc, 0];

num_1_resistor_0 = eval(subs(num_1, resistor_amortecimento, 0));
deno_1_resistor_0 = eval(subs(deno_1, resistor_amortecimento, 0));

num_1_resistor_1 = eval(subs(num_1, resistor_amortecimento, 1));
deno_1_resistor_1 = eval(subs(deno_1, resistor_amortecimento, 1));

num_1_resistor_10 = eval(subs(num_1, resistor_amortecimento, 10));
deno_1_resistor_10 = eval(subs(deno_1, resistor_amortecimento, 10));

func_transf_correnteRede_tensaoFiltro_comResistenciaAmort_0 = ...
    tf(num_1_resistor_0, deno_1_resistor_0);

func_transf_correnteRede_tensaoFiltro_comResistenciaAmort_1 = ...
    tf(num_1_resistor_1, deno_1_resistor_1);

func_transf_correnteRede_tensaoFiltro_comResistenciaAmort_10 = ...
    tf(num_1_resistor_10, deno_1_resistor_10);


%%% CONSIDERANDO O RESISTOR DE AMORTECIMENTO E A RESISTENCIA DOS
%%% INDUTORES

num_2 = num_1;

deno_2 = [capacitor_filtro_calc * indutancia_filtro_calc * indutancia_rede_calc, ...
    capacitor_filtro_calc * (indutancia_rede_calc * (resistor_amortecimento + resistencia_indutancia_filtro) ...
    + indutancia_filtro_calc * (resistor_amortecimento + resistencia_indutancia_rede)), ...
    indutancia_rede_calc + indutancia_filtro_calc + capacitor_filtro_calc * ...
    (resistencia_indutancia_filtro * resistor_amortecimento + resistencia_indutancia_filtro * resistencia_indutancia_rede + ...
    resistor_amortecimento * resistencia_indutancia_rede), ...
    resistencia_indutancia_filtro + resistencia_indutancia_rede
    ];

func_transf_correnteRede_tensaoFiltro_comResistencias = tf(...
    eval(subs(num_2, resistor_amortecimento, 1)), ...
    eval(subs(deno_2, resistor_amortecimento, 1)));

figure(1);

subplot(1,2,1);
bode(func_transf_correnteRede_tensaoFiltro_comResistenciaAmort_0, ...
    func_transf_correnteRede_tensaoFiltro_comResistenciaAmort_1, ...
    func_transf_correnteRede_tensaoFiltro_comResistenciaAmort_10);
legend('Rd = 0', 'Rd = 1', 'Rd = 10');

subplot(1,2,2);
bode(func_transf_correnteRede_tensaoFiltro_comResistencias);
legend('Filtro nao ideal');