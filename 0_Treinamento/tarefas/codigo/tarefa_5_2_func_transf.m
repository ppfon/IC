%%%%% FUNCOES DE TRANSFERENCIA - SEM RESISTENCIA
num_1 = 1;
deno_1 = [capacitor_filtro_calc * indutancia_filtro_calc * indutancia_rede_calc, 0, ...
    indutancia_rede_calc + indutancia_filtro_calc, 0]; 

num_2 = [capacitor_filtro_calc * indutancia_rede_calc, 0, 1];
deno_2 = [capacitor_filtro_calc * indutancia_rede_calc * indutancia_filtro_calc, ...
    0, indutancia_rede_calc + indutancia_filtro_calc, 0];

func_transf_correnteRede_tensaoFiltro = tf(num_1, deno_1);
func_transf_correnteFiltro_tensaoFiltro = tf(num_2, deno_2);


resistencia_indutancia_filtro = eval(subs(omega_rede * indutancia_filtro_calc/40, freq_rede, 60));
resistencia_indutancia_rede = eval(subs(omega_rede * indutancia_rede_calc/40, freq_rede, 60));

num_3 = 1;
deno_3 = [indutancia_rede_calc * indutancia_filtro_calc * capacitor_filtro_calc, ...
    capacitor_filtro_calc * (indutancia_rede_calc * resistencia_indutancia_rede + indutancia_filtro_calc * resistencia_indutancia_filtro), ...
    indutancia_filtro_calc + indutancia_rede_calc + (capacitor_filtro_calc * resistencia_indutancia_rede * resistencia_indutancia_filtro), ...
    resistencia_indutancia_rede + resistencia_indutancia_filtro];

func_transf_correnteRede_tensaoFiltro_comResistencia = tf(num_3, deno_3);

figure(1);
subplot(1,2,1);
bode(func_transf_correnteRede_tensaoFiltro, func_transf_correnteFiltro_tensaoFiltro);
legend('G_{gi}', 'G_{fi}');

subplot(1,2,2);
bode(func_transf_correnteRede_tensaoFiltro, func_transf_correnteRede_tensaoFiltro_comResistencia);
legend('Sem resistor', 'Com resistor');