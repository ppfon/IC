# %%
import matlab.engine
import parameters as param
import scipy.io
from scipy.optimize import curve_fit
import numpy as np
import json

# import matplotlib.pyplot as plt

# Carrega os arquivos .m
eng = matlab.engine.start_matlab()

# %%
binv = np.array(scipy.io.loadmat("Binv1.mat").get("Binv1"))
bg = np.array(scipy.io.loadmat("Bg1.mat").get("Bg1"))
pcp_ind_lcl = np.array(scipy.io.loadmat("Pcp_ind_LCL.mat").get("Pcp_ind_LCL"))
p_cap_lcl = np.array(scipy.io.loadmat("P_cap_LCL.mat").get("P_cap_LCL"))
pswitches_inv_cond = np.array(
    scipy.io.loadmat("Pchaves_inv_cond.mat").get("Pchaves_inv_cond")
)
pswitches_inv_sw = np.array(
    scipy.io.loadmat("Pchaves_inv_sw.mat").get("Pchaves_inv_sw")
)
# i_cap = np.array(scipy.io.loadmat("I_cap.mat").get("I_cap"))
pbat = np.array(scipy.io.loadmat("Pot_bat.mat").get("Pot_bat"))
pswitches_conv_cc_cond = np.array(
    scipy.io.loadmat("Pchaves_conv_cc_cond.mat").get("Pchaves_conv_cc_cond")
)
pswitches_conv_cc_sw = np.array(
    scipy.io.loadmat("Pchaves_conv_cc_sw.mat").get("Pchaves_conv_cc_sw")
)
Pcp_inter1 = np.array(scipy.io.loadmat("Pcp_ind_bt.mat").get("Pcp_ind_bt"))
binter1 = np.array(scipy.io.loadmat("Bind1.mat").get("Bind1"))
pbat2 = np.array(scipy.io.loadmat("Pot_bat2.mat").get("Pot_bat2"))
pswitches_conv_cc_cond2 = np.array(
    scipy.io.loadmat("Pchaves_conv_cc_cond2.mat").get("Pchaves_conv_cc_cond2")
)
pswitches_conv_cc_sw2 = np.array(
    scipy.io.loadmat("Pchaves_conv_cc_sw2.mat").get("Pchaves_conv_cc_sw2")
)
Pcp_inter2 = np.array(scipy.io.loadmat("Pcp_ind_bt2.mat").get("Pcp_ind_bt2"))
binter2 = np.array(scipy.io.loadmat("Bind2.mat").get("Bind2"))
Pgrid = np.array(scipy.io.loadmat("Pot_grid.mat").get("Pot_grid"))

# %% Cálculo das perdas magnéticas nos indutores do filtro LCL
print("Core loss calculation: inverter side inductor of the LCL filter...")

def core_loss_func(mag_flux_dens, count):
    mag_flux_dens = matlab.double(list(np.append(mag_flux_dens, mag_flux_dens[0])))
    time = matlab.double(list(np.arange(0, 1 / param.fn, param.ts)))
    count += 1
    print(count, end=" ")
    return eng.coreloss(
        time, mag_flux_dens, float(param.cn), float(param.xn), float(param.kn), 1
    )  # perdas em W/m3


bg_ac = np.array(
    [
        binv[i][int(len(binv[i]) - ((1 / 60) / (1 / (9000 * 120))) + 1) :]
        for i in range(0, len(binv))
    ]
)

core_loss = np.array([core_loss_func(bg_ac[i][:], i) for i in range(0, len(binv))])
plosses_core_linv_lcl = 3 * core_loss * param.vn * 1e-9  # Perdas em W

print("\nCore loss calculation: grid side inductor of the LCL filter...")
bg_ac = np.array(
    [
        bg[i][int(len(bg[i]) - ((1 / 60) / (1 / (9000 * 120))) + 1) :]
        for i in range(0, len(bg))
    ]
)
core_loss = np.array([core_loss_func(bg_ac[i][:], i) for i in range(0, len(bg))])
plosses_core_lg_lcl = 3 * core_loss * param.vn * 1e-9  # Perdas em W

print("\nCore loss calculation: interleaved inductor of the dc/dc converter 1...")
bg_ac = np.array(
    [
        binter1[i][int(len(binter1[i]) - ((1 / param.fswb) / param.ts) + 1) :]
        for i in range(0, len(binter1))
    ]
)
core_loss = np.array([core_loss_func(bg_ac[i][:], i) for i in range(0, len(binter1))])
plosses_core_inter1 = 3 * core_loss * param.vn_inter * 1e-9  # Perdas em W

print("\nCore loss calculation: interleaved inductor of the dc/dc converter 2...")
bg_ac = np.array(
    [
        binter1[i][int(len(binter1[i]) - ((1 / param.fswb) / param.ts) + 1) :]
        for i in range(0, len(binter1))
    ]
)
core_loss = np.array([core_loss_func(bg_ac[i][:], i) for i in range(0, len(binter2))])
plosses_core_inter2 = 3 * core_loss * param.vn_inter * 1e-9  # Perdas em W

print("\nCopper loss calculation: resistors of the LCL filter...")
plosses_copper_lcl = pcp_ind_lcl

print("ESR loss calculation: capacitors of the LCL filter...")
plosses_esr_lcl = pcp_ind_lcl

print("\nCopper loss calculation: interleaved inductor of the dc/dc converter 1...")
plosses_copper_inter1 = Pcp_inter1

print("\nCopper loss calculation: interleaved inductor of the dc/dc converter 2...")
plosses_copper_inter2 = Pcp_inter2

print("Conduction loss calculation: inverter switches...")
plosses_cond_inv = pswitches_inv_cond

print("Switching loss calculation: inverter switches...")
plosses_switch_inv = pswitches_inv_sw

print("Conduction loss calculation: interleaved 1 switches...")
plosses_cond_inter1 = pswitches_conv_cc_cond

print("Conduction loss calculation: interleaved 2 switches...")
plosses_cond_inter2 = pswitches_conv_cc_cond2

print("Switching loss calculation: interleaved 1 switches...")
plosses_switch_inter1 = pswitches_conv_cc_sw

print("Switching loss calculation: interleaved 2 switches...")
plosses_switch_inter2 = pswitches_conv_cc_sw2

print("Total power losses calculation...")
total_power_losses = (
    # plosses_dc_link
    +plosses_core_linv_lcl
    + plosses_core_lg_lcl
    + plosses_copper_lcl
    + plosses_esr_lcl
    + plosses_cond_inv
    + plosses_switch_inv
    + plosses_core_inter1
    + plosses_core_inter2
    + plosses_copper_inter1
    + plosses_copper_inter2
    + plosses_cond_inter1
    + plosses_cond_inter2
    + plosses_switch_inter1
    + plosses_switch_inter2
)

# %%
print("Efficiency calculation...")
# efficiency = ((1 - total_power_losses / (pbat + pbat2)) * 100)[0]    # Discharge
# Pin = (pbat + pbat2)[0]    # Discharge

efficiency = ((1 - total_power_losses / abs(Pgrid)) * 100)[0]  # Charge
Pin = abs(Pgrid)[0]

print("Save json file...")
with open("efficiency_bess.json", "w") as arquivo:
    efficiency_list = efficiency.tolist()
    json.dump(efficiency_list, arquivo)

with open("total_power_losses_bess.json", "w") as arquivo:
    total_power_losses_list = total_power_losses.tolist()
    json.dump(total_power_losses_list[0], arquivo)

with open("pin.json", "w") as arquivo:
    Pin_list = Pin.tolist()
    json.dump(Pin_list, arquivo)

print("Complete")
# %%
