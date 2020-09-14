import calculateQ as C
from scipy import linalg
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse
import math

# Initial value
F_1 = np.array([[0, 0, 0, 0],[0, 0, 0, 0],[1, 0, 0, 0],[0, 1, 0, 0]])
F_2 = np.array([[0, 0, 0, 0], [0, 0, 0, 0], [1, 0, 0, 0], [0, 1, 0, 0]])
G_1 = np.array([[0, 0],[0, 0],[1, 0], [0, 1]])
G_2 = np.array([[1, 0], [0, 1], [0, 0], [0, 0]])
theW = np.array([[0.64, 0], [0, 0.04]])
theX_1 = np.array([[0.64, 0, 0, 0],[0, 0.04, 0, 0],[0,0,1.2,0.3], [0, 0, 0.3, 1]])

# Calculate
[phi, Q] = C.calculate_PhiandQ(F_1, G_1, theW, 1)
theX_result1 = phi@theX_1@phi.transpose() + Q
print(theX_result1)

#theX_2 = np.hstack([np.vstack([theW, np.zeros(theW.shape)]), np.vstack([np.zeros(theX_result1.shape), theX_result1])])
theX_2=theX_result1;
[phi, Q] = C.calculate_PhiandQ(F_2, G_2, theW, 1)
theX_result2 = phi@theX_result1@phi.transpose() + Q
print(theX_result2)

# Plot
fig = plt.figure(0,figsize=(12,9))
ax = fig.add_subplot(111, aspect='equal')
theX2_xy=theX_result2[2:4,2:4]
eig1,v1=linalg.eig(theX_result1[2:4,2:4])
eig2,v=linalg.eig(theX2_xy)
print(eig1)
e = Ellipse(xy = (1,1), width = theX_result1[2][2], height = theX_result1[3][3], angle = np.arctan(eig1[0].real/eig1.real[1])/math.pi*180)
e2 = Ellipse(xy = (2,2), width = theX_result2[2][2], height = theX_result2[3][3], angle = np.arctan(eig2.real[0]/eig2.real[1])/math.pi*180)
ax.add_artist(e)
ax.add_artist(e2)

e.set_facecolor("green")
e2.set_facecolor("blue")

plt.xlim(0, 4)
plt.ylim(0, 4)
ax.grid(True)

plt.show()