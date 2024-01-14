# The Unsupervised Learning Trick

**Purpose:** Show the unsupervised learning trick on the mnist data using a Random Forest.<!--more-->

The unsupervised learning trick is done by creating a new class in a classification problem using simulated data.

The data is simulated by randomly sampling from the **univariate empirical distribution** for each feature (not the **multivariate empirical distribution**).
For this new class each feature is independent wrt. the empirical distribution:

$$\mathbb{P}(X_1, \dots, X_n) = \mathbb{P}(X_1) \cdots \mathbb{P}(X_n)$$

As explained by Adele Cutler in [1]:

The Unsupervised Learning Trick. Label the “real” data as class 1. Construct cases from a synthetic second class as follows:

1. Randomly select the value for variable 1 from all the observed values of variable 1.
2. Independently, randomly select the value for variable 2 from all the observed values of variable 2.
3. Similarly for variables 3,...,M.

The Synthetic Second Class. The synthetic second class has the same marginal distributions as the “real” data, but we have destroyed all the dependencies between the variables. Now we have a 2-class classification problem.

Run random forests !

## References

[1] Slide 57-58. state-of-the-art-data-mining-using-random-forest-leo-breiman-adele-cutler.pdf

[2] http://yann.lecun.com/exdb/mnist/
