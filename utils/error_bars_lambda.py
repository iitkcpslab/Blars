import numpy as np
import matplotlib.pyplot as plt
# include if using a Jupyter notebook
#%matplotlib inline


# Data for spec1
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
p1m = [l25_mean, l50_mean, l75_mean, l100_mean]
error = [l25_std, l50_std, l75_std, l100_std]
width = 0.35       # the width of the bars: can also be len(x) sequence

#p1 = plt.bar(x_pos, p1m, width, yerr=error)
fig, ax = plt.subplots()
rects1 = ax.bar(x_pos - width/2, p1m, width, label=r'$\phi1$', yerr=error)

# Data for spec4
l100 = np.array([9 , 9, 9])
l75 = np.array([7 , 8, 11, 9])
l50 = np.array([10, 10, 12, 9])
l25 = np.array([10 , 11, 14, 9])

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
p1m = [l25_mean, l50_mean, l75_mean, l100_mean]
error = [l25_std, l50_std, l75_std, l100_std]
width = 0.35       # the width of the bars: can also be len(x) sequence

rects2 = ax.bar(x_pos + width/2, p1m, width, label=r'$\phi4$', yerr=error)


# Add some text for labels, title and custom x-axis tick labels, etc.
ax.set_ylabel('# Iterations)',fontsize=20)
ax.set_xlabel(r'$\lambda$',fontsize=20)
ax.set_xticks(x_pos)
for tick in ax.xaxis.get_major_ticks():
                tick.label.set_fontsize(20)
for tick in ax.yaxis.get_major_ticks():
                tick.label.set_fontsize(20)
ax.set_xticklabels(labels)
ax.legend(prop={'size': 18})

'''
def autolabel(rects):
    """Attach a text label above each bar in *rects*, displaying its height."""
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom')


autolabel(rects1)
autolabel(rects2)
'''
fig.tight_layout()
plt.ylim([0, 80])
plt.savefig('lambda.png')
plt.show()

'''
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
plt.savefig('lambda.png')
plt.show()
'''
