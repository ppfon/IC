import numpy as np

# Seta se o cálculo é para carga ou descarga
set_mode = 0  # 1-Descarga 0-Carga

# Paramâtros do sistema
fswb = 9000  # Frequência de chaveamento do conv cc/cc. Essa também é a oscilação da densidade de fluxo que será usada para computar as perdas magnéticas
ts = 1 / (fswb * 120)  # sample dos dados coletados
fn = 60  # frequência fundamental

# Informação do capacitor do dc-link
ers_100 = 20e-3
freq_c = np.array(
    [
        50.71,
        55.41,
        58.78,
        63.28,
        69.14,
        74.44,
        83.15,
        92.89,
        103.01,
        114.21,
        128.52,
        148.96,
        175.22,
        206.11,
        246.05,
        293.73,
        355.86,
        431.14,
        522.33,
        681.29,
        915.25,
        1229.54,
        1831.56,
        2648.97,
        3719.74,
        5541.02,
        7554.49,
        10926.01,
        15570.68,
    ]
)  # Frequencias do gráfico freq x ERS presente no datasheet do capacitor

ratio_ers = np.array(
    [
        1.25,
        1.22,
        1.18,
        1.15,
        1.12,
        1.09,
        1.05,
        1.02,
        0.99,
        0.97,
        0.95,
        0.92,
        0.9,
        0.88,
        0.86,
        0.83,
        0.81,
        0.8,
        0.79,
        0.78,
        0.77,
        0.76,
        0.75,
        0.74,
        0.73,
        0.72,
        0.72,
        0.71,
        0.7,
    ]
)  # ERSs do gráfico freq x ERS presente no datasheet do capacitor

n_cap_series = 3  # Número de capacitores em série no dc-link
n_cap_strings = 3  # Número de strings de capacitores

# LCL
n_ind_series_lcl = 1  # Número de Indutores em série no filtro LCL

# parâmetros do núcleo escolhido para os indutores do filtro LCL do
# inversor e dos interleaved
vn = 407000  # mm3
# vn_inter = 4 * 407000  # mm3     4 stack cores
kn = 595.864  # constante
xn = 2.042  # expoente B
cn = 1.052  # expoente f

# SOCs correspondentes ao inicio e fim dos cálculos
soc_min_dis = 20  # SOC min na descarga

# tf = eng.THD(1)
