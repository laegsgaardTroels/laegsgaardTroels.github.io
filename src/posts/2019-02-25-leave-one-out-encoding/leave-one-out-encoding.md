Leave one out encoding is a new feature encoding technique used by a Kaggle Grandmaster<!--more--> Owen Zhang.

The technique is described in [1], as


*So here is something that is very easy to do actually for encoding categorical feature by doing the mean response. This is a very simple data set, we have a categorical feature, the UserID, And for the level A1 we have six observations. Four of them are in the training data, and two of them are in the test data. For the training data you have the response variable then 0 1 1 0, and in the test data you wouldn’t have the response variable. So here, I show how to encode this into a numerical. So what you do it to calculate, for the training data, the average response for everything but that observation. So for the first one, it’s 0. For this particular observation there are 3 other observations in the same level, there’s number 2 3 4. And there’s two out of three (that’s why it’s 0.667). The second one, it also has 3 other observations, but it’s 1 0 0 (so it’s 0.333). Do not use itself. If you use it itself, then you will be overfitting the same data.*

*Sometimes it also helps to add random noise on to your training set data. It helps you smooth over very frequently-occurring values. For example, if you do have this, you will see that [these numbers can be thrown] into GBM, GBM goes nuts because it treats them as special values. So if you add small noise on top of that, it actually makes it a little more real from a data perspective. You do not need any such special treatment for the testing data. Testing data is a straight average of the response value for that level, for the training. So two out of four (that’s 0.5). So the basic thing I need to do to use categorical features in GBM. This is much easier to do compared to building a separate ridge regression, and I do this very, very often. That’s Amazon. The amazon competition is a very simple data set. Mostly do feature engineerings on anonymized categorical features. And the response is 1 or 0.*
	- Owen Zhang

It can be seen like the stacking technique with the average value for each level of the categorical feature as the response variable. The stacking technique is a widely used ensemble learning technique used in a lot of winning solutions in Kaggle, it is therefore not surprising that such a technique as the above works, especially for categorical features with many level, where the above trick might be used to somewhat circumvent the *curse of dimensionality*.

## References:
[1] [Featured Talk: #1 Kaggle Data Scientist Owen Zhang. Blog post](https://nycdatascience.com/blog/meetup/featured-talk-1-kaggle-data-scientist-owen-zhang/)
