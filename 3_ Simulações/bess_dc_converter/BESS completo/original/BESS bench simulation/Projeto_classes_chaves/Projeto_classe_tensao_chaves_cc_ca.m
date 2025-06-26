clc;
clear;
close all;

% Tensão da bateria
load('Bat_dis')
Vbat_li = data(3,:);
Vbat_la = data(3,:);
soc = data(4,:);

% Níveis de baixa tensão
bt = 100:5:1000;

% tensão minima da bateria para SOC de 0%
Bat_vrate_Li_0SOC = 1+(14.4-10.5)/14.4;  % Lion
Bat_vrate_La_0SOC = 1+(14.4-10.5)/14.4;  % Lead-acid

% tensão minima da bateria para SOC de 20%
Bat_vrate_Li_20SOC = 1+(14.4-Vbat_li(find(soc<=20,1)))/14.4;     % Lion
Bat_vrate_La_20SOC = 1+(14.4-Vbat_la(find(soc<=20,1)))/14.4;     % Lead-acid

% tensão minima da bateria para SOC de 25%
Bat_vrate_Li_25SOC = 1+(14.4-Vbat_li(find(soc<=25,1)))/14.4;     % Lion
Bat_vrate_La_25SOC = 1+(14.4-Vbat_la(find(soc<=25,1)))/14.4;     % Lead-acid

% tensão minima da bateria para SOC de 30%
Bat_vrate_Li_30SOC = 1+(14.4-Vbat_li(find(soc<=30,1)))/14.4;     % Lion
Bat_vrate_La_30SOC = 1+(14.4-Vbat_la(find(soc<=30,1)))/14.4;     % Lead-acid

% tensão minima da bateria para SOC de 50%
Bat_vrate_Li_50SOC = 1+(14.4-Vbat_li(find(soc<=50,1)))/14.4;     % Lion
Bat_vrate_La_50SOC = 1+(14.4-Vbat_la(find(soc<=50,1)))/14.4;     % Lead-acid

% tensão minima da bateria para SOC de 75%
Bat_vrate_Li_75SOC = 1+(14.4-Vbat_li(find(soc<=75,1)))/14.4;     % Lion
Bat_vrate_La_75SOC = 1+(14.4-Vbat_la(find(soc<=75,1)))/14.4;     % Lead-acid

% Projeto das chaves do inversor para o sistema sem estágio cc/cc para SOC minimo de 0%
for i=1:length(bt)
    % Barramento minimo com 4% de folga
    Vdcmin(i) = 1.04*(bt(i)*sqrt(2));
    % Valor da tensão bloqueada
    Vblock_Li(i) = Bat_vrate_Li_0SOC*Vdcmin(i);  
    Vblock_La(i) = Bat_vrate_La_0SOC*Vdcmin(i);  
end

clear Vdcmin;
% Projeto das chaves do inversor para o sistema sem estágio cc/cc para SOC minimo de 10%
for i=1:length(bt)
    % Barramento minimo com 4% de folga
    Vdcmin(i) = 1.04*(bt(i)*sqrt(2));
    % Valor da tensão bloqueada
    Vblock_Li_20(i) = Bat_vrate_Li_20SOC*Vdcmin(i);  
    Vblock_La_20(i) = Bat_vrate_La_20SOC*Vdcmin(i);  
end

clear Vdcmin;
% Projeto das chaves do inversor para o sistema sem estágio cc/cc para SOC minimo de 25%
for i=1:length(bt)
    % Barramento minimo com 4% de folga
    Vdcmin(i) = 1.04*(bt(i)*sqrt(2));
    % Valor da tensão bloqueada 
    Vblock_Li_25(i) = Bat_vrate_Li_25SOC*Vdcmin(i);  
    Vblock_La_25(i) = Bat_vrate_La_25SOC*Vdcmin(i);  
end

clear Vdcmin;
% Projeto das chaves do inversor para o sistema sem estágio cc/cc para SOC minimo de 30%
for i=1:length(bt)
    % Barramento minimo com 4% de folga
    Vdcmin(i) = 1.04*(bt(i)*sqrt(2));
    % Valor da tensão bloqueada 
    Vblock_Li_30(i) = Bat_vrate_Li_30SOC*Vdcmin(i);  
    Vblock_La_30(i) = Bat_vrate_La_30SOC*Vdcmin(i);  
end

clear Vdcmin;
% Projeto das chaves do inversor para o sistema sem estágio cc/cc para SOC minimo de 50%
for i=1:length(bt)
    % Barramento minimo com 4% de folga
    Vdcmin(i) = 1.04*(bt(i)*sqrt(2));
    % Valor da tensão bloqueada 
    Vblock_Li_50(i) = Bat_vrate_Li_50SOC*Vdcmin(i);  
    Vblock_La_50(i) = Bat_vrate_La_50SOC*Vdcmin(i);  
end

clear Vdcmin;
% Projeto das chaves do inversor para o sistema sem estágio cc/cc para SOC minimo de 75%
for i=1:length(bt)
    % Barramento minimo com 4% de folga
    Vdcmin(i) = 1.04*(bt(i)*sqrt(2));
    % Valor da tensão bloqueada 
    Vblock_Li_75(i) = Bat_vrate_Li_75SOC*Vdcmin(i);  
    Vblock_La_75(i) = Bat_vrate_La_75SOC*Vdcmin(i);  
end

clear Vdcmin;
% Projeto das chaves do inversor para o sistema com estágio cc/cc
for i=1:length(bt)
    % Barramento minimo com 4% de folga
    Vdcmin(i) = 1.04*(bt(i)*sqrt(2));
    % Valor da tensão bloqueada
    Vblock_cc(i) = Vdcmin(i);   
end

% Classes de tensão das chaves (Considerando 60% de margem devido aos raios cósmicos)
clt_600  = 600*ones(1,length(bt))*0.628;
clt_1200 = 1200*ones(1,length(bt))*0.628;
clt_1700 = 1700*ones(1,length(bt))*0.628;
clt_3300 = 3300*ones(1,length(bt))*0.628;

axes1 = axes('Parent',figure,'fontSize',14);
x0=1;
y0=1;
width=450;
height=300;
set(gcf,'units','points','position',[x0,y0,width,height])

plot(bt,Vblock_La,'linewidth',1.2)
hold on
plot(bt,Vblock_La_20,'linewidth',1.2)
plot(bt,Vblock_cc,'linewidth',1.2)
plot(bt,clt_600)
plot(bt,clt_1200)
plot(bt,clt_1700)
plot(bt,clt_3300)
plot(bt(find(bt>=690,1,'first')),Vblock_cc(find(bt>=690,1,'first')),'o')
plot(bt(find(bt>=690,1,'first')),Vblock_La_20(find(bt>=690,1,'first')),'o')
plot(bt(find(bt>=690,1,'first')),Vblock_La(find(bt>=690,1,'first')),'o')
plot(bt(find(bt>=440,1,'first')),Vblock_cc(find(bt>=440,1,'first')),'o')
plot(bt(find(bt>=440,1,'first')),Vblock_La_20(find(bt>=440,1,'first')),'o')
plot(bt(find(bt>=440,1,'first')),Vblock_La(find(bt>=440,1,'first')),'o')
plot(bt(find(bt>=380,1,'first')),Vblock_cc(find(bt>=380,1,'first')),'o')
plot(bt(find(bt>=380,1,'first')),Vblock_La_20(find(bt>=380,1,'first')),'o')
plot(bt(find(bt>=380,1,'first')),Vblock_La(find(bt>=380,1,'first')),'o')
plot(bt(find(bt>=220,1,'first')),Vblock_cc(find(bt>=220,1,'first')),'o')
plot(bt(find(bt>=220,1,'first')),Vblock_La_20(find(bt>=220,1,'first')),'o')
plot(bt(find(bt>=220,1,'first')),Vblock_La(find(bt>=220,1,'first')),'o')
plot(bt(find(bt>=180,1,'first')),Vblock_cc(find(bt>=180,1,'first')),'o')
plot(bt(find(bt>=180,1,'first')),Vblock_La_20(find(bt>=180,1,'first')),'o')
plot(bt(find(bt>=180,1,'first')),Vblock_La(find(bt>=180,1,'first')),'o')
grid
axis([100 1000 0 2400])
set(axes1,'YTick',[0:200:2400]);
set(axes1,'XTick',[100:100:1000]);
ylabel('V_{dc,min} [V]');
xlabel('Grid Voltage [V]');
legend('SOC_{(Vdc_{min})} = 0','SOC_{(Vdc_{min})} = 20%','With cc/cc converter')
set(gca,'fontname','times','FontSize',15)


pos = find(bt == 690);

Vdcmin = Vdcmin(pos)