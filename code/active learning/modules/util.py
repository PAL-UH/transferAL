from sklearn.datasets import make_hastie_10_2

#make_hastie_10_2 binary classification with labels 0, 1 instead of -1.0, 1.0
#
def hastie(n_samples):
    X, y = make_hastie_10_2(n_samples=n_samples)
    for i, item in enumerate(y):
        if item < 0:
            y[i]=0
        else:
            y[i]=1
    y = y.astype(int)
    return X, y

def classname(o):
    return str(o.__class__.__name__).replace('Classifier', '').replace('LinearDiscriminantAnalysis', 'LDA').replace('QuadraticDiscriminantAnalysis', 'QDA')