---
image: /assets/images/2017-05-21-perceptron/neuron.png
category: Algorithm
code: https://github.com/laegsgaardTroels/perceptron
---
The Perceptron by Rosenblat is one of the earliest machine learning algorithms. It was proposed as a model of an artificial neuron, and can be used for classification.<!--more-->
The Perceptron belongs to the class of models specified by,  

$$
\begin{aligned}
	h(x) & = f(\sum_{j=1}^{m}w_jx_j + b), \quad w\in\mathbb{R}^d, b\in\mathbb{R}
\end{aligned}
$$

where $f$ is a non-linear function, for the Perceptron $f=\text{sign}$. This class of models is the basic building block for **feedforward neural networks**.

The perceptron works like an artificial neuron, when fed an $x\in\mathbb{R}^d$ to be classified, the observations will be weighed using the weights: $w_1,w_2,\dots,w_m\in\mathbb{R}$; if the artificial neuron is stimulated enough, $\sum_jw_jx_j>-b \Rightarrow h(x)=1$, then the neuron fires. 

<img src="/assets/images/2017-05-21-perceptron/perceptron.svg" width="800" height="auto">

A problem with the perceptron is that the activation function is not differentiable, making it unclear how to fit a multilayer perceptron, defined below, with this choice of activation function, instead one can choose a differentiable activation-function like the sigmoid function: $f(x)=\sigma(x)=\frac{1}{1+e^{-x}}$, used in logistic regression, which has the nice property that: $\sigma'(x)=\sigma(x)(1-\sigma(x))$, making it easy to differentiate.


The Perceptron can be fit to data using the **perceptron learning algorithm** which can be derived from the **stochastic gradient descent** (SGD) algorithm for optimization. SGD is a **gradient based optimization method**. Gradient based optimization methods are the main workhose in todays practice for fitting neural networks.

To derive it use the loss function:

$$
\begin{aligned}
\mathcal{L}(w) 
&= - \sum_{i:h(x_i)\neq y_i}w'x_i y_i\\
&= - \sum_{i=1}^{N} \min(w'x_i y_i,0)\\
&= - \sum_{i=1}^{N} L_i(w)
\end{aligned}
$$

One notices that for a single observation $(x_i, y_i)$ that:

$$
\begin{cases}
    \text{Correctly classified: }w'x_iy_i>0 \Rightarrow L_i(w)=\min(w'x_i y_i,0)=0 \Rightarrow \frac{\partial}{\partial w} L_i(w) = 0\\
    \text{Wrongly classified: } \  w'x_iy_i<0 \Rightarrow L_i(w)=\min(w'x_i y_i,0)<0 \Rightarrow \frac{\partial}{\partial w} L_i(w) = x_i y_i
\end{cases}
$$

So applying stochastic gradient descent with $\eta\in(0,1)$ amounts to the update rule:

$$
\begin{aligned}
w_{t+1}
&= w_t - \eta \frac{\partial}{\partial w} L_i(w) \\
&= \begin{cases}
    \text{Correctly classified: } w_t \\
    \text{Wrongly classified: } w_t - \eta x_i y_i
\end{cases}
\end{aligned}
$$

With a new observation $(x_i, y_i)$ in each iteration. That is basically the perceptron learning algorithm. 

# References

[1] Rosenblatt. “The Perceptron: A probalistic model for information storage and organization in the brain”. 1958.
