---
author: "Troels L\xE6gsgaard"
category: Thoughts
code: ''
content: ''
date: '2021-05-02'
day: '02'
excerpt: While working at Maersk there was a power-to-speed model used for planning,
  basically a polynomial inferred from a regression, taking in some extra inputs besides
  power and outputting speed. For this model there was defined valid input power levels.
  In this post I will talk about my thoughts on why it seems useful to define the
  operational range AND data type of an inferred function in an operational setting.
  [...]
image: /assets/images/2021-05-02-operationel-range/maersk-vessel.jpeg
month: '05'
title: Operationel Range
url: /posts/2021-05-02-operationel-range.html
year: '2021'
---

While working at Maersk there was a power-to-speed model used for planning, basically a polynomial inferred from a regression, taking in some extra inputs besides power and outputting speed. For this model there was defined valid input power levels. In this post I will talk about my thoughts on why it seems useful to define the operational range AND data type of an inferred function in an operational setting. <!--more-->

## Basic Implementation

A very basic implementation of the operational range would be. If implementered in Python then I would also use dicts to specify the datatypes.

```python
# dtype.py

# The range of variables in X.
X_RANGE = {'power': [0, 80000]}

# The range of variables in y.
Y_RANGE = {'speed': [0, 30]}

# The datatype of the inputs.
X_DTYPE = {'power': 'float64'}

# The datatype of the output.
Y_DTYPE = {'power': 'float64'}
```

Useful things you can do when you define the operational range:

- Test that predictions are within the operational range for input values in the operational range.
- Create standard reports to investigate yourself or ideally subject matter experts.
- Approximate the partial relationships between two variables by partial dependence plots (or a rough approximation to it).
- If the datatypes are specified then this it is easy to specify the spec of an API to users.
- If the datatypes is specified then parsing mistakes can be avoided by creating functions to load the data.

## Related Thought: Basic Functional Relationships

To be even more specific one could specify a range on valid speed levels $[s_{min}(p), s_{max}(p)]$ for each power level $p$. This would naturally lead to a lower bound on how bad the model is:

$$
\lvert \text{prediction}(p) - \text{actual}(p) \rvert \leq s_{max}(p) - s_{min}(p)
$$

## Related Thought:  Sample of the data

With a sample of the data one can do similar thing but above could be faster to compute and easier to standardize.

A sample of the data with 1000 rows are however easy to keep as a `pytest` fixture so I would probably do this anyway.
