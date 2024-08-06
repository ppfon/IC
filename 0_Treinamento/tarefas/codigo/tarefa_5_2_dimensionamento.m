%%%%% RAZOES %%%%%


r_freq_chave_resso = 3; % razao entre freq_chave e freq_res
r_indutores = 1; % razao entre indutor_filtro/indutor_rede;
r_capacitores = 2; % adotando 

freq_resso = freq_chave/r_freq_chave_resso;
omega_resso = 2*pi*freq_resso;
omega_rede = 2*pi*freq_rede;

r_freq_chave_rede = freq_chave/freq_rede;

%%%%% INDUTORES %%%%%
impedancia_rede_base = tensao_rede_linha_rms ^ 2 / pot_rede_aparente;

indutancia_rede_base = impedancia_rede_base/omega_rede;

indutancia_total_pu = r_freq_chave_resso/r_freq_chave_rede ... 
    * (1+r_indutores)/(sqrt(r_indutores * r_capacitores));

indutancia_total = indutancia_total_pu * indutancia_rede_base;

%%%%% RESULTADOS %%%%%

corrente_rede_base = pot_rede_aparente/(sqrt(3)*tensao_rede_linha_rms);


m = sqrt(3)/tensao_barramento * sqrt(...
    (tensao_rede_linha_rms^2)/3 ...
    + (omega_rede * indutancia_total * corrente_rede_base)^2);

func_m = 3/2 * m ^ 2 - 3*sqrt(3)/pi + (9/8 * 3/2 - 9/8 * sqrt(3)/pi * m ^ 4);

corrente_rede_thd = 1/corrente_rede_base * (pi * tensao_barramento)/(12*impedancia_rede_base) ...
    * sqrt(r_indutores)/(1 + r_indutores) * sqrt(r_capacitores)/(r_freq_chave_resso ^ 3) ...
    * 1/( (1 - 6/m) ^ 2 * omega_rede ^ 2 - omega_resso ^ 2) * func_m;

q = (r_capacitores - 1)/sqrt(r_capacitores) * (1 + r_indutores)/sqrt(r_indutores) ...
    * r_freq_chave_resso * 1/r_freq_chave_rede;

fp_rede = 1 - (q ^ 2)/2;

capacitor_filtro = r_capacitores * indutancia_total/(impedancia_rede_base ^ 2);

indutancia_filtro =  indutancia_total/(r_indutores + 1);
indutancia_rede = r_indutores * indutancia_filtro;

f_res = 1/(2 * pi) * sqrt(1/capacitor_filtro * (1/indutancia_filtro + 1/indutancia_rede));
