%% parâmetros da simulação
fsw = 9000; %% frequência de chaveamento do conversor
fsample = fsw; %utilizado nos parâmetros do controle(transformação e controle)
Tsample = 1/fsample;
fdsp = fsample*120;
passo = 1/(fdsp); %% incremento de simulação

%% Temperatura inicial dos dispositivos
Temp_inicial_IGBT = 1500;
Temp_inicial_diodo = 1000;

Temp_inicial_IGBT_inv = 800;
Temp_inicial_diodo_inv = 800;

%% Parâmetros da rede e da carga
fn = 60;
wn = 2*pi*fn;

pot_ref = 1000;
Vdc = 500;  %% Dc-link voltage

%% Malha externa Vdc
Cdc = 4.7e-3;         

%% Bateria
Nb_series  = 16;
Nb_strings = 1;
Rint = Nb_series*7.1e-3;   %%Resistência interna das baterias
Soc_min = 50;    % SOC[%]
Soc_max = 100;
Vdco = 13.6*Nb_series;                        %% tensão inicial dc-link

% Dc/dc Parameters
Lb = 4e-3;              %Indutor do Boost
Rb = 0.55;              %Resistência série do indutor
N = 3;                  %Número de braços do interleaved
fswb = 9000;
Tsb = 1/(fswb);

%%Ganhos do controlador do dc/dc
%% ganho controle de corrente do boost e buck
Kc = Vdc/(Rb+N*Rint);
Tm = Lb/(Rb+N*Rint);
fc = fswb/20;
Kpb = 2*pi*fc*Tm/Kc;        %%MOdelagem no arquivo .m
Kib = 2*pi*fc/Kc;           %%MOdelagem no arquivo .m

%% ganho controle de tensão do buck (Modo tensão constante)
fc1 = 10;
fc2 = fc1/20;
Kpvbu = fc2/(N*Rint*(fc1-fc2));      %%MOdelagem no arquivo .m
Kivbu = 2*pi*fc1*(Kpvbu);      %%MOdelagem no arquivo .m
