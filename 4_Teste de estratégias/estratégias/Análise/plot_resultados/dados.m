% Dados de aquisição
fs = 9e3; Ts = 1/fs; fn = 60;
tempo = linspace(0, 20/fn, fs);

% Dados da rede

theta = 0; 
wn = 2*pi*fn;
theta_c = 2*pi/3;

v_ff = 220;
deseq = 0.4;
amp_a = v_ff*sqrt(2)/sqrt(3); 
amp_b = amp_a*deseq; amp_c = amp_a*deseq;

Va = amp_a * cos(wn * tempo + theta - 0*theta_c);
Vb = amp_b * cos(wn * tempo + theta - 1*theta_c);
Vc = amp_c * cos(wn * tempo + theta - 2*theta_c);

Vabc = [ Va ; Vb ; Vc ;];

a = exp(theta_c * j); k_comp_sime = 1;
matriz_comp_sime = [ 1 1 1; 1 a a^2; 1 a^2 a];
Vabc_comp = k_comp_sime/3 * matriz_comp_sime * Vabc;

Vabc_comp_pos = Vabc_comp(1,:);
Vabc_comp_neg = Vabc_comp(2,:);

Valfabeta_comp = abc2alpha(Vabc_comp);
Valfabeta_comp_pos = Valfabeta_comp(1,:);
Valfabeta_comp_neg = Valfabeta_comp(2,:);

mag_pos = abs(Vabc_comp_pos);
mag_neg = abs(Vabc_comp_neg);

u = mag_neg/mag_pos;

Vabc_orto = comp_orto(Vabc);
Vabc_orto_comp = comp_sime(Vabc_orto);
Vabc_orto_comp_pos = Vabc_orto_comp(1,:);
Vabc_orto_comp_neg = Vabc_orto_comp(2,:);