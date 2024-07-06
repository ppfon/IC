%Armazena as caracteristicas da simulacao atual
mdl = plecs('get', '', 'CurrentCircuit');
%salva path do scope na raiz, se estiver dentro de
%um subsystem usar '/Sub/Scope'
%scopepath = [mdl '/Psemi'];

%carrega um valor inicial em Ih e H  A=Ih 
loadStructure = struct('Vdc_bat1', 0);
loadStructure = struct('Vdc_bat2', 0);
loadStructure = struct('Ibat1', 0);
loadStructure = struct('Ibat2', 0);

%Cria uma estrutura com as variaveis
varStructure = struct('ModelVars', loadStructure);
%Apaga o scope
%plecs('scope', scopepath, 'ClearTraces');

% Discharge
% Vdc_bat1Vals = [189.43, 188.99, 188.4, 187.8, 187.22, 186.67, 186.14, 185.67, 185.16, 184.68, 184.17, 183.69, 183.18, 182.68, 182.22, 181.76, 181.32, 180.87, 180.23, 179.46, 178.97]

% Vdc_bat2Vals = [189.44, 189.0, 188.44, 187.86, 187.29, 186.69, 186.11, 185.53, 184.99, 184.44, 183.9, 183.35, 182.8, 182.25, 181.64, 181.07, 180.55, 179.92, 179.21, 178.02, 176.01]

% Ibat1Vals = [14.564, 14.524, 14.594, 14.684, 14.684, 14.725, 14.682, 14.551, 14.492, 14.38, 14.321, 14.146, 14.043, 13.926, 13.745, 13.626, 13.535, 13.528, 13.723, 14.329, 14.236]

% Ibat2Vals = [14.431, 14.427, 14.492, 14.513, 14.499, 14.59, 14.623, 14.629, 14.587, 14.569, 14.51, 14.422, 14.326, 14.168, 14.176, 14.069, 13.896, 13.959, 14.039, 14.549, 14.569]


% Charge
Vdc_bat1Vals = [196.99, 199.57, 201.17, 202.29, 203.14, 203.8, 204.32, 204.76, 205.13, 205.45, 205.72, 205.99, 206.22, 206.43, 206.64, 206.84, 207.04, 207.23, 207.41, 207.6, 207.77, 207.95, 208.13, 208.31, 208.49, 208.69, 208.87, 209.06, 209.26, 209.46, 209.63, 209.82, 210.02, 210.23, 210.44, 210.64, 210.86, 211.09, 211.3, 211.54, 211.77, 212.03, 212.25, 212.53, 212.8, 213.1, 213.41, 213.76, 214.1, 214.49, 214.9, 215.41, 215.97, 216.59, 217.36, 218.25, 219.28, 220.41, 222.06, 224.89, 228.24, 230.77, 232.27]
Vdc_bat2Vals = [196.21, 198.98, 200.68, 201.88, 202.82, 203.55, 204.15, 204.63, 205.04, 205.4, 205.71, 205.98, 206.23, 206.47, 206.68, 206.9, 207.09, 207.29, 207.49, 207.69, 207.88, 208.07, 208.26, 208.46, 208.64, 208.84, 209.07, 209.26, 209.45, 209.66, 209.88, 210.08, 210.3, 210.52, 210.74, 210.98, 211.19, 211.42, 211.65, 211.88, 212.13, 212.39, 212.64, 212.92, 213.19, 213.52, 213.84, 214.18, 214.58, 215.06, 215.53, 216.1, 216.77, 217.64, 218.54, 219.69, 221.19, 223.46, 225.85, 225.4, 227.43, 225.72, 224.44]
Ibat1Vals = [-4.9482, -4.9211, -4.9315, -4.94, -4.9492, -4.9492, -4.9457, -4.9446, -4.9463, -4.936, -4.9254, -4.9427, -4.9514, -4.9302, -4.9319, -4.9322, -4.9528, -4.9457, -4.9451, -4.9524, -4.9167, -4.9197, -4.9175, -4.9155, -4.9007, -4.9313, -4.9111, -4.9088, -4.9279, -4.923, -4.8922, -4.8947, -4.8933, -4.8978, -4.8985, -4.8775, -4.8874, -4.891, -4.879, -4.8921, -4.8802, -4.89, -4.8697, -4.8709, -4.8738, -4.883, -4.8747, -4.8983, -4.8782, -4.8829, -4.8743, -4.9001, -4.9064, -4.8976, -4.9038, -4.915, -4.9177, -4.8707, -4.8512, -4.896, -4.9109, -4.7092, -4.4446]
Ibat2Vals = [-5.1216, -5.0855, -5.0797, -5.0499, -5.0537, -5.0727, -5.0815, -5.0574, -5.0674, -5.0763, -5.0726, -5.0728, -5.0669, -5.072, -5.0571, -5.0741, -5.0499, -5.0627, -5.0772, -5.0683, -5.061, -5.0619, -5.0746, -5.0636, -5.0436, -5.0302, -5.0951, -5.0736, -5.0516, -5.0396, -5.0768, -5.0578, -5.0535, -5.0375, -5.0656, -5.0725, -5.0463, -5.0561, -5.0419, -5.0241, -5.0242, -5.037, -5.0186, -5.0273, -5.0011, -5.0309, -5.0276, -5.008, -5.0211, -5.0551, -5.037, -5.0177, -5.0134, -5.0486, -5.034, -5.0059, -4.9965, -5.0245, -4.9188, -3.8789, -3.8346, -4.7498, -3.2469]

for ki = 1:length(Vdc_bat1Vals)
    varStructure.ModelVars.Vdc_bat1 = Vdc_bat1Vals(ki);
    varStructure.ModelVars.Vdc_bat2 = Vdc_bat2Vals(ki);
    varStructure.ModelVars.Ibat1 = Ibat1Vals(ki);
    varStructure.ModelVars.Ibat2 = Ibat2Vals(ki);
    Out = plecs('simulate', varStructure);
    Pchaves_inv_cond(ki) = Out.Values(1,end);
    Pchaves_inv_sw(ki) = Out.Values(2,end);
    Binv1(ki,:) = Out.Values(3,(end-(2/(60)/(1/(9000*120))):end));
    Bg1(ki,:) = Out.Values(4,(end-(2/(60)/(1/(9000*120))):end));
    Pcp_ind_LCL(ki) = Out.Values(5,end);
    P_cap_LCL(ki) = Out.Values(6,end);
    Pchaves_conv_cc_cond(ki,:) = Out.Values(7,end);
    Pchaves_conv_cc_sw(ki,:) = Out.Values(8,end);
    Pcp_ind_bt(ki,:) = Out.Values(9,end);
    Bind1(ki,:) = Out.Values(10,(end-(2/(60)/(1/(9000*120))):end));
    Pchaves_conv_cc_cond2(ki,:) = Out.Values(11,end);
    Pchaves_conv_cc_sw2(ki,:) = Out.Values(12,end);
    Bind2(ki,:) = Out.Values(13,(end-(2/(60)/(1/(9000*120))):end));
    Pcp_ind_bt2(ki,:) = Out.Values(14,end);
    Pot_grid(ki) = Out.Values(15,end);
    Pot_bat(ki) = Out.Values(16,end);
    Pot_bat2(ki) = Out.Values(17,end);
end    
                       
%salva a variavel
save("Pchaves_inv_cond.mat", "-mat", "Pchaves_inv_cond")
save("Pchaves_inv_sw.mat", "-mat", "Pchaves_inv_sw")
save("Binv1.mat", "-mat", "Binv1")
save("Bg1.mat", "-mat", "Bg1")
save("Pcp_ind_LCL.mat", "-mat", "Pcp_ind_LCL")
save("P_cap_LCL.mat", "-mat", "P_cap_LCL")
save("Pchaves_conv_cc_cond.mat", "-mat", "Pchaves_conv_cc_cond")
save("Pchaves_conv_cc_sw.mat", "-mat", "Pchaves_conv_cc_sw")
save("Pcp_ind_bt.mat", "-mat", "Pcp_ind_bt")
save("Bind1.mat", "-mat", "Bind1")
save("Pchaves_conv_cc_cond2.mat", "-mat", "Pchaves_conv_cc_cond2")
save("Pchaves_conv_cc_sw2.mat", "-mat", "Pchaves_conv_cc_sw2")
save("Bind2.mat", "-mat", "Bind2")
save("Pcp_ind_bt2.mat", "-mat", "Pcp_ind_bt2")
save("Pot_grid.mat", "-mat", "Pot_grid")
save("Pot_bat.mat", "-mat", "Pot_bat")
save("Pot_bat2.mat", "-mat", "Pot_bat2")

% Bg_f(kx,:) = Out.Values(8,(end-1/(60*1/(12000*256))):end);
% Bi_f(kx,:) = Out.Values(9,(end-1/(60*1/(12000*256))):end);