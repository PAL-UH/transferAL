import numpy as np

class Oracle:
    def __init__(self, X, y):
        self.X = X
        self.y = y
        self.queried = []

    def query(self, loc):
        self.queried.append(loc)
        return self.y(loc)

    def random_query(self):
        while True:
            loc = np.random.random_integers(0, len(self.X)-1, 1)[0]
            if loc not in self.queried:
                self.queried.append(loc)
                break
        return loc, self.y[loc]

    def classifier_uncertainty(self, classifier):
        try:
            classwise_uncertainty = classifier.predict_proba(self.X)
        except AttributeError:
            classwise_uncertainty = classifier.decision_function(self.X)

        uncertainty = 1 - np.max(classwise_uncertainty, axis=1)

        return uncertainty

    def uncertainty_sampling(self, classifier, n_instances=1):
        uncertainty = self.classifier_uncertainty(classifier)
        query_idx = self.multi_argmax(uncertainty, n_instances=n_instances)

        return int(query_idx), self.X[query_idx]

    def multi_argmax(self, values, n_instances=1):
        assert n_instances <= len(values), 'n_instances must be less or equal than the size of utility'
        max_idx = np.argpartition(-values, n_instances-1, axis=0)[:n_instances]

        return max_idx

