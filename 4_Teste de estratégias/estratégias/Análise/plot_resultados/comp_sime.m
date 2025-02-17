function componentes = comp_sime(Vabc) 


% k = sqrt(3) é a versão invariante em potência

k_comp_sime = 1;
theta_c = 2*pi/3;
a = exp(theta_c * j);

matriz_comp_sime = [ 1 1 1; 1 a a^2; 1 a^2 a];

componentes = k_comp_sime/3 * matriz_comp_sime * Vabc;