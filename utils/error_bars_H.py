import numpy as np
import matplotlib.pyplot as plt
# include if using a Jupyter notebook
#%matplotlib inline

# Data
H4 = np.array([0])
H6 = np.array([30 , 28, 47, 56])
H8 = np.array([32, 28, 47, 34])
H10 = np.array([32, 26, 55, 40])
H12 = np.array([35, 42, 63, 46])
H15 = np.array([40, 46, 75, 53])

# Calculate the average
H4_mean = np.mean(H4)
H6_mean = np.mean(H6)
H8_mean = np.mean(H8)
H10_mean = np.mean(H10)
H12_mean = np.mean(H12)
H15_mean = np.mean(H15)

# Calculate the standard deviation
H4_std = np.std(H4)
H6_std = np.std(H6)
H8_std = np.std(H8)
H10_std = np.std(H10)
H12_std = np.std(H12)
H15_std = np.std(H15)

# Define labels, positions, bar heights and error bar heights
labels = ['6', '8', '10','12','15']
x_pos = np.arange(len(labels))
p1m = [ H6_mean, H8_mean, H10_mean, H12_mean, H15_mean]
error = [ H6_std, H8_std, H10_std, H12_std, H15_std]

width = 0.45       # the width of the bars: can also be len(x) sequence

fig, ax = plt.subplots()
rects1 = ax.bar(x_pos - width/2, p1m, width, label=r'$\phi1$', yerr=error)


# Data for spec4
H4 = np.array([0])
H6 = np.array([13 , 27, 17 , 9])
H8 = np.array([11, 7, 17, 21])
H10 = np.array([9, 7, 23, 15])
H12 = np.array([9, 7, 27, 17])
H15 = np.array([9, 7, 33, 20])

# Calculate the average
H4_mean = np.mean(H4)
H6_mean = np.mean(H6)
H8_mean = np.mean(H8)
H10_mean = np.mean(H10)
H12_mean = np.mean(H12)
H15_mean = np.mean(H15)

# Calculate the standard deviation
H4_std = np.std(H4)
H6_std = np.std(H6)
H8_std = np.std(H8)
H10_std = np.std(H10)
H12_std = np.std(H12)
H15_std = np.std(H15)

# Define labels, positions, bar heights and error bar heights
labels = ['6', '8', '10','12','15']
x_pos = np.arange(len(labels))
p1m = [ H6_mean, H8_mean, H10_mean, H12_mean, H15_mean]
error = [ H6_std, H8_std, H10_std, H12_std, H15_std]
width = 0.45       # the width of the bars: can also be len(x) sequence

rects2 = ax.bar(x_pos + width/2, p1m, width, label=r'$\phi4$', yerr=error)


# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('# Iterations)',fontsize=20)
ax.set_xlabel('H',fontsize=20)
ax.set_xticks(x_pos)
for tick in ax.xaxis.get_major_ticks():
                tick.label.set_fontsize(20)
for tick in ax.yaxis.get_major_ticks():
                tick.label.set_fontsize(20)
ax.set_xticklabels(labels)
#ax.legend()
ax.legend(prop={'size': 20})

fig.tight_layout()
plt.ylim([0, 90])
plt.savefig('H.png')
plt.show()




'''
# Build the plot
fig, ax = plt.subplots()
ax.bar(x_pos, CTEs,
       yerr=error,
       align='center',
       alpha=0.5,
       ecolor='black',
       color='green',
       capsize=10)
ax.set_ylabel('# Iterations)')
ax.set_xticks(x_pos)
ax.set_xticklabels(labels)
#ax.set_title(r'$\lambda$')
ax.set_xlabel('H')
ax.yaxis.grid(True)


# Save the figure and show
plt.tight_layout()
plt.savefig('H.png')
plt.show()
'''
