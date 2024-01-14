---
author: "Troels L\xE6gsgaard"
category: Riddle
code: ''
content: ''
date: '2019-07-28'
day: '28'
excerpt: The [Monty Hall problem](https://en.wikipedia.org/wiki/Monty_Hall_problem)
  is an awesome brain teaser [...]
image: /assets/images/2019-07-28-lazy-proof-of-monty-hall/goat.png
month: '07'
title: Lazy Proof Of Monty Hall
url: /posts/2019-07-28-lazy-proof-of-monty-hall.html
year: '2019'
---


The [Monty Hall problem](https://en.wikipedia.org/wiki/Monty_Hall_problem) is an awesome brain teaser<!--more-->:

" *Suppose you're on a game show, and you're given the choice of three doors: Behind one door is a car; behind the others, goats. You pick a door, say No. 1, and the host, who knows what's behind the doors, opens another door, say No. 3, which has a goat. He then says to you, "Do you want to pick door No. 2?" Is it to your advantage to switch your choice?* "

The suprising result is that the contestants who stick to their original choice only have a $\frac{1}{3}$ probability of winning. But if you switch you will have $\frac{2}{3}$.

<img src="/assets/images/2019-07-28-lazy-proof-of-monty-hall/goat.png">

## Proof

A lazy proof of this goes as follows: Assume $X_1, X_2, X_3\in\{1,2,3\}$ are random variables representing the door chosen first $X_1$, the door which the host opens $X_2$ and the last door one can select $X_3$ instead of the first door $X_1$. Assume the car is behind door $C$.

$$
\begin{aligned}
\mathbb{P}(X_3=C)
  & = \overset{\leq \mathbb{P}(X_3=X_1)=0}{\mathbb{P}(X_3=C, X_1 = C)} +
      \mathbb{P}(X_3=C, X_1 \neq C) \\
  & = \mathbb{P}(X_3=C, X_1 \neq C) \\
  & = \mathbb{P}(X_3=C, X_1 \neq C) +
      \overset{=\mathbb{P}(X_2=C)=0}{\mathbb{P}(X_3 \neq C, X_1 \neq C)}\\
  & = \mathbb{P}(X_1 \neq C) \\
  & = \frac{2}{3}
\end{aligned}
$$

For the first equal sign one uses the law of total probability. For the second equal sign one observes that if door 3 has the car and door 1 has the car then door 1 and door 3 are the same, but this has 0 probability. For the third equal sign one observes that door 1 and door 3 is not the car iff door two is the car, which has 0 probability. For the fourth equal sign one uses the law of total probability. And the fifth equal sign is simply the probability that the first door chosen is not the car.

## Intuition

To understand *why* this is so one can think what happens if one repick: Assume you hit a goat in the first pick then the host will show the goat behind the other door and you will get the car i.e. if you repick then you win if your first pick is a goat, which is $\frac{2}{3}$!

This is even more obvious if there were 100 doors: Assume there is a car behind one of the 100 doors and goats behind the rest. The game host then opens 98 doors with goats behind them, and asks if you want to repick to the last unopen door. Now you still win if you pick a goat at first and loses if you don't, so if you repick you now have a $\frac{99}{100}$ probability of winning.

## References

[1] [wikipedia](https://en.wikipedia.org/wiki/Monty_Hall_problem)
