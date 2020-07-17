import numpy as np
import matplotlib.pyplot as plt
# include if using a Jupyter notebook
#%matplotlib inline

# Data
a02 = np.array([00 ,00, 00])
a05 = np.array([60, 37, 55,45])
a07 = np.array([65, 30, 51, 55])
a1 = np.array([75, 45, 30, 55])

# Calculate the average
a02_mean = np.mean(a02)
a05_mean = np.mean(a05)
a07_mean = np.mean(a07)
a1_mean = np.mean(a1)

# Calculate the standard deviation
a02_std = np.std(a02)
a05_std = np.std(a05)
a07_std = np.std(a07)
a1_std = np.std(a1)

# Define labels, positions, bar heights and error bar heights
labels = ['0.20', '0.50', '0.70', '1']
x_pos = np.arange(len(labels))
p1m = [a02_mean, a05_mean, a07_mean, a1_mean]
error = [a02_std, a05_std, a07_std, a1_std]

width = 0.35       # the width of the bars: can also be len(x) sequence

fig, ax = plt.subplots()
rects1 = ax.bar(x_pos - width/2, p1m, width, label=r'$\phi1$', yerr=error)


# Data for spec4
a02 = np.array([00 ,00, 00])
a05 = np.array([9, 8, 16, 24])
a07 = np.array([8, 20, 17, 30])
a1 = np.array([8, 20, 20, 32])

# Calculate the average
a02_mean = np.mean(a02)
a05_mean = np.mean(a05)
a07_mean = np.mean(a07)
a1_mean = np.mean(a1)

# Calculate the standard deviation
a02_std = np.std(a02)
a05_std = np.std(a05)
a07_std = np.std(a07)
a1_std = np.std(a1)

# Define labels, positions, bar heights and error bar heights
labels = ['0.20', '0.50', '0.70', '1']
x_pos = np.arange(len(labels))
p1m =  [a02_mean, a05_mean, a07_mean, a1_mean]
error = [a02_std, a05_std, a07_std, a1_std]
width = 0.35       # the width of the bars: can also be len(x) sequence

rects2 = ax.bar(x_pos + width/2, p1m, width, label=r'$\phi4$', yerr=error)


# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('# Iterations)',fontsize=20)
ax.set_xlabel(r'$\delta$',fontsize=20)
#ax.get_children()[1].set_color('black') 
ax.set_xticks(x_pos)
for tick in ax.xaxis.get_major_ticks():
                tick.label.set_fontsize(20)
for tick in ax.yaxis.get_major_ticks():
                tick.label.set_fontsize(20)
ax.set_xticklabels(labels)
ax.legend(prop={'size': 18})

fig.tight_layout()
#plt.ylim([0,100])
plt.savefig('alpha.png')
plt.show()
'''
# Build the plot
fig, ax = plt.subplots()
ax.bar(x_pos, CTEs,
       yerr=error,
       align='center',
       alpha=0.5,
       ecolor='black',
       color=colors,
       capsize=10)
ax.set_ylabel('# Iterations)')
ax.set_xticks(x_pos)
ax.set_xticklabels(labels)
#ax.set_title(r'$\lambda$')
ax.set_xlabel(r'$\alpha(\delta)$')
ax.yaxis.grid(True)


# Save the figure and show
plt.tight_layout()
plt.savefig('alpha.png')
plt.show()
'''
