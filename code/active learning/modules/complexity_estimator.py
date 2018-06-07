import numpy as np
import scipy
import sklearn.metrics as metr

class ComplexityEstimator:
    def __init__(self, X, y, n_windows=10, nK=1):
        assert (n_windows > 0)
        assert (len(set(y)) > 1)
        assert (len(X) == len(y))
        assert (nK < len(y))
        self.X = X
        self.y = y
        self.seeds = np.random.random_integers(0, len(X) - 1, n_windows)
        self.tree = scipy.spatial.cKDTree(X)
        self.labels = set(y)

        self.Ks = np.arange(1, len(self.X) + 1, step=nK)  # ckdTree starts counting from 1
        self.Hs = np.zeros(len(self.Ks))
        self.ws = np.ndarray((n_windows, len(self.Ks)))

        for i, k in enumerate(self.Ks):
            for j, seed in enumerate(self.seeds):
                h = self._H(k=k, seed=seed)
                self.ws[j, i] = h
                self.Hs[i] = np.sum(self.ws[:, i]) / len(self.seeds)

        for h in self.Hs:
            assert h >= 0.0 and h <= len(self.labels) - 1.0

    def get_k_complexity(self):
        return self.Ks, self.Hs

    def auc(self, normalize=True):
        if normalize:
            return metr.auc(self.Ks, self.Hs, reorder=True) / len(self.y)
        return metr.auc(self.Ks, self.Hs, reorder=True)

    def get_w_complexity(self):
        return self.ws

    def get_seed(self, window):
        return self.seeds[window]

    def _nearest_neighbors(self, k, seed):
        return self.tree.query(self.X[seed, :], k=k)

    def _H(self, k, seed):
        H = 0
        d, ii = self._nearest_neighbors(k, seed)
        neighbors = self.y[ii]
        for c in self.labels:
            same_c = np.where(neighbors == c)[0]
            r = len(same_c)/float(k)
            if r > 0:
                H += (r * np.log2(r))
        return -H