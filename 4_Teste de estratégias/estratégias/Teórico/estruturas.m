% Dados de aquisição
fs = 9e3; Ts = 1/fs;
fn = 60;
tempo = linspace(0, 15/fn, fs);

% Dados da rede

theta = 0; 
wn = 2*pi*fn;
theta_c = 2*pi/3;

deseq = 0.3;
amp_a = 180; 
amp_b = amp_a*deseq; amp_c = amp_a*deseq;

Va = amp_a * cos(wn * tempo + theta - 0*theta_c);
Vb = amp_b * cos(wn * tempo + theta - 1*theta_c);
Vc = amp_c * cos(wn * tempo + theta - 2*theta_c);

Vabc = [ Va ; Vb ; Vc ;];

%plot(tempo, Vabc);
Valfabeta_comp = abc2alpha(comp_sime(Vabc));
Valfabeta_comp_pos = Valfabeta_comp(1,:);
Valfabeta_comp_neg = Valfabeta_comp(2,:);

mag_pos = abs(Valfabeta_comp_pos) + 0.001;
mag_neg = abs(Valfabeta_comp_neg) + 0.001;

% Ganhos das estratégias
kp_pos = 1; kp_neg = 1; kq_pos = 1; kq_neg = -1;
theta_pos = angle(Valfabeta_comp_pos); theta_neg = angle(Valfabeta_comp_neg);


% Referências de potências
P_ref = 2000; Q_ref = 1000;


mag_pot_ativa = P_ref * ( (kp_pos + kp_neg) .* mag_pos .* mag_neg .* cos(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (kp_pos .* mag_pos.^2 + kp_neg .* mag_neg.^2)  + ... 
                Q_ref * ( (kq_pos - kq_neg) .* mag_pos .* mag_neg .* sin(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (kq_pos .* mag_pos.^2 + kq_neg .* mag_neg.^2);

num = Q_ref * ( (kq_pos - kq_neg) .* mag_pos .* mag_neg .* sin(2 * wn * tempo + theta_pos - theta_neg) );
deno = (kq_pos .* mag_pos.^2 + kq_neg .* mag_neg.^2);

figure(1);
subplot(2,1,1); 
plot(tempo,  num); 
subplot(2,1,2);
plot(tempo, mag_pot_ativa); 