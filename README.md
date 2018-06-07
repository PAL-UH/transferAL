# transferAL

### Description:

The following repository contains all pieces of code used in generating the results found in *"Domain Adaptation by Transferring Model-Complexity Priors Across Tasks"* by Ricardo Vilalta, Kinjal Ghupta, Dainis Boumber and Mikhail M.Meskhi.

Please read the documentation below to understand how to reproduce our results. At this current stage of the repository, some code is in MATLAB and some in Python. Also not everything is well sorted. I am currently trying to organize everything properly. 

The Bayesian Domain Adaptation algorithm that we propose is available here but contains some minor bugs are I am fixing so it can be reusable by anyone. If you have any trouble with the code, please create issues or email us directly. 

### Abstract:

We propose a Maximum a Posteriori approach to estimate model complexity in supervised learning by assuming the existence of a previous learning task from which we can build a prior distribution. Our method is embedded in a domain-adaptation scenario, where the goal is to learn a model on a target domain characterized by a shortage of class labels; this difficulty is commonly tackled by exploiting information from a similar source domain where there is an abundance of examples and class labels. In contrast to previous work, our approach does not rely on the proximity of source and target distributions. Instead we simply assume a strong similarity in model complexity across domains, and use active learning to mitigate the dependency on source examples. Our work leads to a new formulation for the likelihood as a function of empirical error using a theoretical learning bound; the result is a novel mapping from generalization error to a likelihood estimation. Results using two real astronomical problems, Supernova Ia classification and identification of Mars landforms, show two main advantages with our approach: increased accuracy performance and substantial savings in computational cost.

### Usage:

There are multiple algorithms available here. To use them, just simply run them in MATLAB or Python with parameters configuration defined in the `results/` directory files or defined in their respective papers mentioned below. Be aware, that to reconstruct our experimental setup, you will require heavy computational power (Our hardware is made of a 3712-core computer cluster with 8 Tesla C2075 GPUs, and 22 GTK570 GPUs, 120TB Lustre Filesystem, and 127TB storage space). 


I divided the code and data into categories to understand how things are classified here: 

_**Active Learning**_

The models below were used with Active Learning methodology utilizing the Uncertainty sampling strategy:

- Multilayered Perceptron (NN + AL) - [Python]()
- Logistic Regression (LR + AL) - [Python]()
- Support Vector Machine (SVM + AL) - [Python]()

_**Domain Adaptation**_

We used available Domain Adaptation algorithms and other state of the art algorithms out there which are:

- Subspace Alignment (SA) - [MATLAB]() / [Paper]()
- Transfer Joint Matching (TJM) - [MATLAB]() / [Paper]()
- Geodesic Flow Kernel (GFK) - [MATLAB]() / [Paper]()
- Adaptation Regularization based Transfer Learning (ARTL) - [MATLAB]() / [Paper]()
- Joint Distribution Adaptation (JDA) - [MATLAB]() / [Paper]()
- Domain-Adversarial Training of Neural Networks (DATNN) - [MATLAB]() / [Paper]()
- Joint Distribution Optimal Transportation (JDOT-SVM) - [MATLAB]() / [Paper]()
- Joint Distribution Optimal Transportation (JDOT-NN) - [MATLAB]() / [Paper]()

_**Our Algorithm**_

Propsed algorithm in our paper:

- Bayesian Domain Adaptation (BDA) - [MATLAB]()

_**Statistical Tests**_

Most appropriate statistical test conducted to determine statistical significance in results observed. The statistical tests were run in R:

- Paired Two-Tailed t-Test with Unequal Variance - [R]() / [More tests](https://github.com/b0rxa/scmamp)

_**Datasets**_

We focused on these two datasets which were provided by NASA:

- [Mars]()
- [Supernova]()

### References:

- The code used in these experiments such as the Domain Adaptation algorithms were used from [@jindongwang's](https://github.com/jindongwang/transferlearning/tree/master/code) transfer learning repository. Some modifications were made to satisfy our needs. **Notice**: Do not confuse Balanced Distribution Adaptation (BDA) with our Bayesian Domain Adapation (BDA)! 

- Statistical tests conducted in R studio were inspired by [@scmamps's](https://github.com/b0rxa/scmamp) compiled comparison of different statistical tests. 


[X] TODO: Write first draft of README for public.

[ ] TODO: Add all the code i.e. Python, R and MATLAB. 

[ ] TODO: Fix BDA and upload final verison.

[ ] TODO: Update README with more parameter details and usage info.
