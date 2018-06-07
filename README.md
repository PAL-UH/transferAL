# transferAL

### Description:

The following repository contains all pieces of code used in generating the results found in *"Domain Adaptation by Transferring Model-Complexity Priors Across Tasks"* by Ricardo Vilalta, Kinjal Ghupta, Dainis Boumber and Mikhail M.Meskhi.

Please read the documentation below to understand how to reproduce our results. At this current stage of the repository, some code is in MATLAB and some in Python. Also not everything is well sorted. I am currently trying to organize everything properly. 

The Bayesian Domain Adaptation algorithm that we propose is available here but contains some minor bugs are I am fixing so it can be reusable by anyone. If you have any trouble with the code, please create issues or email us directly. 

### Abstract:

We propose a Maximum a Posteriori approach to estimate model complexity in supervised learning by assuming the existence of a previous learning task from which we can build a prior distribution. Our method is embedded in a domain-adaptation scenario, where the goal is to learn a model on a target domain characterized by a shortage of class labels; this difficulty is commonly tackled by exploiting information from a similar source domain where there is an abundance of examples and class labels. In contrast to previous work, our approach does not rely on the proximity of source and target distributions. Instead we simply assume a strong similarity in model complexity across domains, and use active learning to mitigate the dependency on source examples. Our work leads to a new formulation for the likelihood as a function of empirical error using a theoretical learning bound; the result is a novel mapping from generalization error to a likelihood estimation. Results using two real astronomical problems, Supernova Ia classification and identification of Mars landforms, show two main advantages with our approach: increased accuracy performance and substantial savings in computational cost.

### Usage:

There are multiple algorithms available here. To use them, just simply run them in MATLAB or Python with parameters configuration defined in the `results/` directory files or defined in their respective papers mentioned below. Be aware, that to reconstruct our experimental setup, you will require heavy computational power (Our hardware is made of a 3712-core computer cluster with 8 Tesla C2075 GPUs, and 22 GTK570 GPUs, 120TB Lustre Filesystem, and 127TB storage space). 


### Code:

I divided the code into categories to understand how things are classified here: 

[_**Active Learning**_](https://github.com/PAL-UH/transferAL/tree/master/code/active%20learning)

The models below were used with Active Learning methodology utilizing the Uncertainty sampling strategy:

- Multilayered Perceptron (NN + AL) - [Python](https://github.com/PAL-UH/transferAL/blob/master/code/active%20learning/active_learning_baselines.py)
- Logistic Regression (LR + AL) - [Python](https://github.com/PAL-UH/transferAL/blob/master/code/active%20learning/active_learning_baselines.py)
- Support Vector Machine (SVM + AL) - [Python](https://github.com/PAL-UH/transferAL/blob/master/code/active%20learning/active_learning_baselines.py)

[_**Domain Adaptation**_](https://github.com/PAL-UH/transferAL/tree/master/code/domain%20adaptation)

We used available Domain Adaptation algorithms and other state of the art algorithms out there which are:

- Subspace Alignment (SA) - [MATLAB]() / [Paper]()
- Transfer Joint Matching (TJM) - [MATLAB](https://github.com/PAL-UH/transferAL/blob/master/code/domain%20adaptation/TJM/TJM.m) / [Paper](https://github.com/PAL-UH/transferAL/blob/master/papers/tjm.pdf)
- Geodesic Flow Kernel (GFK) - [MATLAB](https://github.com/PAL-UH/transferAL/blob/master/code/domain%20adaptation/GFK/GFK.m) / [Paper](https://github.com/PAL-UH/transferAL/blob/master/papers/gfk.pdf)
- Adaptation Regularization based Transfer Learning (ARTL) - [MATLAB](https://github.com/PAL-UH/transferAL/blob/master/code/domain%20adaptation/ARTL/ARTL.m) / [Paper](https://github.com/PAL-UH/transferAL/blob/master/papers/artl.pdf)
- Joint Distribution Adaptation (JDA) - [MATLAB](https://github.com/PAL-UH/transferAL/blob/master/code/domain%20adaptation/JDA/JDA.m) / [Paper](https://github.com/PAL-UH/transferAL/blob/master/papers/jda.pdf)
- Domain-Adversarial Training of Neural Networks (DATNN) - [MATLAB]() / [Paper]()
- Joint Distribution Optimal Transportation (JDOT-SVM) - [MATLAB]() / [Paper]()
- Joint Distribution Optimal Transportation (JDOT-NN) - [MATLAB]() / [Paper]()

[_**Our Algorithm**_](https://github.com/PAL-UH/transferAL/tree/master/code/proposed%20algorithm)

Propsed algorithm in our paper:

- Bayesian Domain Adaptation (BDA) - [MATLAB](https://github.com/PAL-UH/transferAL/tree/master/code/proposed%20algorithm/bda)

[_**Statistical Tests**_](https://github.com/PAL-UH/transferAL/tree/master/code/statistical%20tests)

Most appropriate statistical test conducted to determine statistical significance in results observed. The statistical tests were run in R:

- Paired Two-Tailed t-Test with Unequal Variance - [R]() / [More tests](https://github.com/b0rxa/scmamp)

### Datasets:

We focused on these two datasets which were provided by NASA:

- [Mars](https://github.com/PAL-UH/transferAL/tree/master/data/mars)
- [Supernova](https://github.com/PAL-UH/transferAL/tree/master/data/supernova)

### Results:

The following links contain all the results that the code in this repo will generate. Some `.png` and `.pdf` files have been manually generated and are included for more insight into our methodology.

- [Active Learning](https://github.com/PAL-UH/transferAL/tree/master/results/active%20learning)
- [Domain Adaptation](https://github.com/PAL-UH/transferAL/tree/master/results/domain%20adaptation)
- [Statistical Tests](https://github.com/PAL-UH/transferAL/tree/master/results/statistical%20tests)

### References:

- The code used in these experiments such as the Domain Adaptation algorithms were used from [@jindongwang's](https://github.com/jindongwang/transferlearning/tree/master/code) transfer learning repository. Some modifications were made to satisfy our needs. **Notice**: Do not confuse Balanced Distribution Adaptation (BDA) with our Bayesian Domain Adapation (BDA)! 

- Statistical tests conducted in R studio were inspired by [@scmamps's](https://github.com/b0rxa/scmamp) compiled comparison of different statistical tests. 


## TODO

[X] TODO: Write first draft of README for public.

[X] TODO: Add all the code Michael has i.e. Python, R and MATLAB. 

[ ] TODO: Fix BDA and upload final verison.

[X] TODO: Update README with more parameter details and usage info.

[ ] TODO: Add missing DA algorithms (DATNN, JDOT-NN, JDOT-SVM).

[ ] TODO: Add statistical test R code.

[ ] TODO: Write documentation for each directory.
