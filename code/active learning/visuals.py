import matplotlib.pyplot as plt
from sklearn.datasets import  make_blobs
import numpy as np

Xs, ys = make_blobs(300, centers=[[0, 0], [0, 1]], cluster_std=0.1)
Xt, yt = make_blobs(300, centers=[[1, -1], [1, 0]], cluster_std=0.2)

figure = plt.figure(figsize=(27, 13))
grid_size = (1, 2)
ax = plt.subplot2grid(grid_size, (0, 0))

ax.set_title('Dist 1')
X1, y1 = make_blobs(300, centers=[[0, 0], [0, 1]], cluster_std=0.1)
X2, y2 = make_blobs(300, centers=[[1, -1], [1, 0]], cluster_std=0.1)
X=np.vstack((X1,X2))
y=np.hstack((y1,y2))
np.savetxt("3dx.csv", X, delimiter=",")
np.savetxt("3dy.csv", y, delimiter=",")
ax.scatter(X[:,0], X[:,1], c=y, cmap='cool', alpha=0.4)
ax = plt.subplot2grid(grid_size, (0, 1))

ax.set_title('Dist 2')
X1, y1 = make_blobs(300, centers=[[0, 0.5], [0, 1]], cluster_std=0.1)
X2, y2 = make_blobs(300, centers=[[1, -1], [1, 0]], cluster_std=0.2)
X3, y3 = make_blobs(300, centers=[[0.4, 0.9], [0, 1]], cluster_std=0.06)
X=np.vstack((X1,X2,X3))
y=np.hstack((y1,y2,y3))
plt.scatter(X[:,0], X[:,1], c=y, cmap='cool', alpha=0.4)
figure.savefig('vis/idea.png')
plt.show()