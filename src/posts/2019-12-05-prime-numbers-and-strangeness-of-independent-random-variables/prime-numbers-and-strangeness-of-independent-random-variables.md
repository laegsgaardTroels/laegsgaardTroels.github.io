A counter intuitive fact about random variables.  <!--more--> 

Assume a probability space $(\Omega, \mathcal{F}, \mathbb{P})$. Where the sample space is finite $\vert\Omega\vert=N$, the events are the powerset of $\Omega$ e.g. $\mathcal{F}=\mathcal{P}(\Omega)$ and the probability is the discrete uniform distribution $\mathbb{P}(A)=\frac{\rvert A \rvert}{N}$.

This is how one can model a lottery. The fun thing is now when $N$ is a **prime number**.

Assume $A,B\in\mathcal{F}$ are two independent events, $A,B\notin\{\Omega, \emptyset \}$, $m=\rvert A\rvert$, $k=\rvert B\rvert$, $n=\rvert A\cap B \rvert$ then

$$
\begin{aligned}
\frac{n}{N} = \mathbb{P}(A\cap B) &= \mathbb{P}(A) \mathbb{P}(B) = \frac{m}{N}\frac{k}{N} \\
&\Downarrow \\
n\cdot N &= m \cdot k
\end{aligned}
$$

Let

$$
\begin{aligned}
n&=\prod_{i}p^n_i \quad k=\prod_{i}p^k_i \\
m&=\prod_{i}p^m_i
\end{aligned}
$$

Be their unique prime factorization. Then

$$
\begin{aligned}
\prod_i p^n_i \cdot N = n\cdot N &= m \cdot k = \prod_i p^m_i \prod_j p^k_j \\
&\Downarrow \\
N \in \{p^m_1, p^m_2,&\dots,p^k_1, p^m_2, \dots\}
\end{aligned}
$$

Because the prime factorization is unique.

But $\forall i,j:$ $p^m_i\leq m<N$ and $p^k_j\leq k<N$. This is a contradiction.

Hence if $N$ is a prime number and $A,B$ are independent then $A,B\in\{\Omega, \emptyset \}$, *the trivial independent events*. But if $N$ is not a prime number then $N=k\cdot m$ for some integers, assume $k,m\geq 2$.
Let $A=\{1,\dots,m\}$ and $B=\{m,2m\dots,km\}$ implies

$$
\begin{aligned}
\mathbb{P}(A) = \frac{1}{m}, \quad \mathbb{P}(B) = \frac{1}{k}, \quad \mathbb{P}(A\cap B) = \frac{1}{N} = \mathbb{P}(A)\mathbb{P}(B)
\end{aligned}
$$

Many other *nontrivial pairs of events* can be constructed in similar ways.

Above is a rewritten proof and example from 2.15 in [1]. As state in this book this implies that when

$$
N=2^{127}-1=170141183460469231731687303715884105727
$$

A prime number. Then there are **no** nontrivial pairs of independent events, and if

$$
N=2^{127}=170141183460469231731687303715884105728
$$

Then there are lots of nontrivial pairs of independent events.

## Example: A Dice

A related thought of mine. Let $X$ be a dice $(\{1,2,3,4,5,6\}, \mathcal{F}, \mathbb{P})$ where $\mathcal{F}=\mathcal{P}(\Omega)$ and the probability is the discrete uniform distribution $\mathbb{P}(A)=\frac{\rvert A \rvert}{N}$ as above.

Now 6 is not a prime number. Its unique prime factorization is $6=2\cdot3$. Each outcome can be mapped 1-1 with an index consisting of two random numbers $I\in\{1,2\}$ and $J\in\{1,2,3\}$ each with uniform distribution e.g. $\mathbb{P}(I=i)=\frac{1}{2}$ and $\mathbb{P}(J=j)=\frac{1}{3}$ for $i=1,2$ and $j=1,2,3$.

As an example:

$$
\begin{aligned}
    I = 1, J = 1 \Rightarrow X = 1 \\
    I = 1, J = 2 \Rightarrow X = 2 \\
    I = 1, J = 3 \Rightarrow X = 3 \\
    I = 2, J = 1 \Rightarrow X = 4 \\
    I = 2, J = 2 \Rightarrow X = 5 \\
    I = 2, J = 3 \Rightarrow X = 6
\end{aligned}
$$

The mapping is not really that important in my view. What is interesting now is that $I$ has 2 outcomes and $J$ has 3 outcomes both **prime** therefore $\mathbb{P}_I$ and $\mathbb{P}_J$ has no independent events. In addition it can be seen that $I$ and $J$ are independent because $\mathbb{P}(I=i, J=j)=\frac{1}{6}=\frac{1}{2}\frac{1}{3}=\mathbb{P}(I=i)\mathbb{P}(J=j)$ per construction.

So you can view a roll of this theoretical die as two independent outcomes from $I$ and $J$ that determines the index of the die. 

## References

[1] Probability With a View Towards Statistics, Two Volume Set: Probability With a View Towards Statistics, Volume I (Chapman & Hall/CRC Probability Series) (Volume 1) 1st Edition. J. Hoffmann-Jørgensen
