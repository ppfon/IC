# %%
import numpy as np
import json
import matplotlib.pyplot as plt
import scipy.io

pnom = 6e3

pbat = np.array(scipy.io.loadmat("Pot_bat.mat").get("Pot_bat"))
pbat2 = np.array(scipy.io.loadmat("Pot_bat2.mat").get("Pot_bat2"))

with open("total_losses.json", "r") as arquivo:
    total_power_losses = np.array(json.load(arquivo))

efficiency = (1 - total_power_losses / (pbat + pbat2)) * 100

pref = np.array(
    [
        pnom,
        pnom * 0.8,
        pnom * 0.6,
        pnom * 0.4,
        pnom * 0.2,
    ]
)
soc = np.array([100, 80, 60, 40, 20])

fig, ax1 = plt.subplots(1, 1)
fig.set_size_inches(8, 6)

efficiency = np.round(efficiency, decimals=2)

N = 1000  # Number of levels
levels = np.unique(np.round(np.linspace(85, 93.6, num=N, endpoint=True), decimals=2))
count1 = ax1.contourf(soc, pref / pnom, efficiency, levels, extend="min", cmap="jet")
ax1.set_xlabel("Soc [%]", fontsize=18)
ax1.set_ylabel("Power [pu]", fontsize=18)
plt.title("3b")
plt.yticks(fontsize=18)
plt.xticks(fontsize=18)
plt.gca().invert_xaxis()
cbar = fig.colorbar(count1, ax=ax1)
cbar.set_label("Efficiency [%]", fontsize=18)
cbar.ax.tick_params(labelsize=18)  # set your label size here
# %%
