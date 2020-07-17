import numpy as np
import matplotlib.pyplot as plt
# include if using a Jupyter notebook
#%matplotlib inline

# Data
l25 = np.array([61 , 63, 65, 70])
l50 = np.array([60, 61, 63])
l75 = np.array([55, 59, 57])
l100 = np.array([55, 55, 55])

# Calculate the average
l25_mean = np.mean(l25)
l50_mean = np.mean(l50)
l75_mean = np.mean(l75)
l100_mean = np.mean(l100)

# Calculate the standard deviation
l25_std = np.std(l25)
l50_std = np.std(l50)
l75_std = np.std(l75)
l100_std = np.std(l100)

# Define labels, positions, bar heights and error bar heights
labels = ['0.25', '0.50', '0.75','1']
x_pos = np.arange(len(labels))
CTEs = [l25_mean, l50_mean, l75_mean, l100_mean]
error = [l25_std, l50_std, l75_std, l100_std]


# Build the plot
fig, ax = plt.subplots()
ax.bar(x_pos, CTEs,
       yerr=error,
       align='center',
       alpha=0.5,
       ecolor='black',
       color='red',
       capsize=10)
ax.set_ylabel('# Iterations)')
ax.set_xticks(x_pos)
ax.set_xticklabels(labels)
#ax.set_title(r'$\lambda$')
ax.set_xlabel(r'$\lambda$')
ax.yaxis.grid(True)


# Save the figure and show
plt.tight_layout()
plt.savefig('bar_plot_with_error_bars.png')
plt.show()

