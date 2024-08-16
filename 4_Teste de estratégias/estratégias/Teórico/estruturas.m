% Dados de aquisição
fs = 9e3; Ts = 1/fs;
fn = 60;
tempo = linspace(0, 20/fn, fs);

% Dados da rede

theta = 0; 
wn = 2*pi*fn;
theta_c = 2*pi/3;

deseq = 0.4;
amp_a = 180; 
amp_b = amp_a*deseq; amp_c = amp_a*deseq;

Va = amp_a * cos(wn * tempo + theta - 0*theta_c);
Vb = amp_b * cos(wn * tempo + theta - 1*theta_c);
Vc = amp_c * cos(wn * tempo + theta - 2*theta_c);

Vabc = [ Va ; Vb ; Vc ;];

Vabc_comp = comp_sime(Vabc);
Vabc_comp_pos = Vabc_comp(1,:);
Vabc_comp_neg = Vabc_comp(2,:);

Valfabeta_comp = abc2alpha(Vabc_comp);
Valfabeta_comp_pos = Valfabeta_comp(1,:);
Valfabeta_comp_neg = Valfabeta_comp(2,:);

mag_pos = abs(Vabc_comp_pos);
mag_neg = abs(Vabc_comp_neg);
u = Vabc_comp(1,:)/Vabc_comp(2,:);

%u = 1/3;

% Ganhos das estratégias
% bpsc 
kp_pos = 1; kp_neg = 0; kq_pos = 1; kq_neg = 0;

%theta_pos = angle(Valfabeta_comp_pos); theta_neg = angle(Valfabeta_comp_neg);
theta_pos = 0; theta_neg = 0;

% Referências de potências
P_ref = 0; Q_ref = 2386.04;


ripple_pot_ativa = P_ref * ( (kp_pos + kp_neg) .* mag_pos .* mag_neg .* cos(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (kp_pos .* mag_pos.^2 + kp_neg .* mag_neg.^2)  + ... 
                Q_ref * ( (kq_pos - kq_neg) .* mag_pos .* mag_neg .* sin(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (kq_pos .* mag_pos.^2 + kq_neg .* mag_neg.^2);

ripple_pot_reativa = Q_ref * ( (kq_pos + kp_neg) .* mag_pos .* mag_neg .* cos(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (kq_pos .* mag_pos.^2 + kq_neg .* mag_neg.^2)  - ... 
                P_ref * ( (kp_pos - kp_neg) .* mag_pos .* mag_neg .* sin(2 * wn * tempo + theta_pos - theta_neg) ) ...
                      ./ (kp_pos .* mag_pos.^2 + kp_neg .* mag_neg.^2);


mag_pot_ativa = u .* sqrt( ...
                ((kp_pos + kp_neg) .* P_ref .* (1 ./ (kp_pos + kp_neg .* u.^2))).^2 + ...
                ((kq_pos - kq_neg) .* Q_ref .* (1 ./ (kq_pos + kq_neg .* u.^2))).^2 );

mag_pot_reativa = u .* sqrt( ...
                 ((kq_pos + kq_neg) .* Q_ref .* (1 ./ (kq_pos + kq_neg .* u.^2))).^2 + ...
                 ((kp_pos - kp_neg) .* P_ref .* (1 ./ (kp_pos + kp_neg .* u.^2))).^2 );


pot_ativa = ripple_pot_ativa; %+ mag_pot_ativa;
pot_reativa = ripple_pot_reativa; %+ mag_pot_reativa;

Vabc_orto = comp_orto(Vabc);
Vabc_orto_comp = comp_sime(Vabc_orto);
Vabc_orto_comp_pos = Vabc_orto_comp(1,:);
Vabc_orto_comp_neg = Vabc_orto_comp(2,:);

i_p = (kp_pos .* Vabc_comp_pos + kp_neg .* Vabc_comp_neg) * P_ref / (kp_pos .* mag_pos .* mag_pos + kp_neg .* mag_neg .* mag_neg);
i_q = (kq_pos .* Vabc_orto_comp_pos + kq_neg .* Vabc_orto_comp_neg) * Q_ref / (kq_pos .* mag_pos .*mag_pos + kq_neg .* mag_neg .* mag_neg);

i_total = i_p + i_q; 

resultado_pu = 0;

% figure(1);
% subplot(2,2,1); 
% plot(tempo, pot_ativa); ylim([-4000 4000]);
% 
% subplot(2,2,2);
% [amp, fase, freq] = calcula_espectro(pot_ativa, Ts, resultado_pu);
% plot(freq, amp, 'r');
% 
% subplot(2,2,3); 
% plot(tempo, pot_reativa);
% 
% subplot(2,2,4);
% plot(Vabc, 'r');
% 
% figure(2);
% subplot(3,1,1);
% plot(imag(Vabc_comp_pos));
% 
% subplot(3,1,2);
% plot(imag(Vabc_comp_neg));
% 
% subplot(3,1,3);
% plot(Vabc_comp(3,:));

figure(3);
plot(tempo, real(Vabc_comp(3,:)));
%Vabc_tempo = [ Va tempo; Vb tempo; Vc tempo;];
Va_tempo = timeseries(Va, tempo'); 
Vb_tempo = timeseries(Vb, tempo'); 
Vc_tempo = timeseries(Vc, tempo');