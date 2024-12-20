ativa = [0.0419665 1500.52 1001.77;
         125.96 1503.63 1000.22; 
         145.706 1497.75 1001.39;
         0.338531 1499.97 999.445;
         4.44746 1500.68 1000.41;];

reativa = [1729.9 0.461923 1152.75; 
           1789.78 64.3119 1146.55;
           1793.48 80.9777 1136.59;
           1784.93 80.8469 1136.59;
           1780.12 0.262 1187.28;];

ativa_std = std(ativa);
reativa_std = std(reativa);
ativa_med = mean(ativa); reativa_med = mean(reativa);

razao_ativa = ativa_std/ativa_med;
razao_reativa = reativa_std/reativa_med;
