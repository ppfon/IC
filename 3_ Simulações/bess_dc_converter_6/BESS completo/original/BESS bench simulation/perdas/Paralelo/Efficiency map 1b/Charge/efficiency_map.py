# %%
import numpy as np
import json
import matplotlib.pyplot as plt
import scipy.io

pnom = 6e3

pgrid = np.array(scipy.io.loadmat("Pot_grid.mat").get("Pot_grid"))
vbat = np.array(scipy.io.loadmat("Vbat.mat").get("Vbat"))
ibat = np.array(scipy.io.loadmat("Ibat.mat").get("Ibat"))

with open("total_losses.json", "r") as arquivo:
    total_power_losses = np.array(json.load(arquivo))

efficiency = (1 - total_power_losses / (-pgrid)) * 100

pref = np.array(
    [
        pnom * 0.40,
        pnom * 0.30,
        pnom * 0.20,
        pnom * 0.10,
        pnom * 0.05
    ]
)
soc = np.array([20, 40, 60, 80, 100])

fig, ax1 = plt.subplots(1, 1)
fig.set_size_inches(8, 6)

efficiency = np.round(efficiency, decimals=2)

N = 1000  # Number of levels
levels = np.unique(np.round(np.linspace(85, 93, num=N, endpoint=True), decimals=2))
count1 = ax1.contourf(soc, pref / pnom, efficiency, levels, extend="min", cmap="jet")
ax1.set_xlabel("Soc [%]", fontsize=18)
ax1.set_ylabel("Power [pu]", fontsize=18)
plt.yticks(fontsize=18)
plt.xticks(fontsize=18)
cbar = fig.colorbar(count1, ax=ax1)
cbar.set_label("Efficiency [%]", fontsize=18)
cbar.ax.tick_params(labelsize=18)  # set your label size here
# This is the fix for the white lines between contour levels
for c in count1.collections:
    c.set_edgecolor("face")
fig.tight_layout()
plt.show(block=False)
input("hit[enter] to end.")
plt.close("all")

# %%