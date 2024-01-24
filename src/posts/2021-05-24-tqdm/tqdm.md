`tqdm` is a nice Python module for creating a progressbar when processing a list of items.<!--more-->

It can be used in a basic for loop:

```python
from tqdm import tqdm

xs = [1, 2, 3]
ys = []
with tqdm(total=len(xs)) as pbar:
    for x in xs:
        ys.append(x ** 2)
        pbar.update()
```

And with `multiprocessing` as well:

```python
import multiprocessing
from tqdm import tqdm

# The number of parallel processes to run.
PARALLELISM = 2

def task(x):
     return x ** 2

xs = [1, 2, 3]
ys = []
with tqdm(total=len(xs)) as pbar:
    with multiprocessing.Pool(processes=PARALLELISM) as pool:
        for y in pool.imap(task, xs):
            ys.append(y)
            pbar.update()
```

# References

[1] https://tqdm.github.io/
