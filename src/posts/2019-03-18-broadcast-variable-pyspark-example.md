---
image: assets/images/base/apache_spark.svg
category: Programming
---

Broadcasting a variable is useful for repeatedly used read-only variables in an application<!--more-->, like large lookup tables or similar. Spark automatically sends all variables referenced in your closures to the worker nodes. While this is convenient, it can also be inefficient because (1) the default task launching mechanism is optimized for small task sizes, and (2) you might, in fact, use the same variable in multiple parallel operations, but Spark will send it separately for each
operation [1, page 104]. A broadcast variable in is an object of type `spark.broadcast.Broadcast[T]`, it wraps a Serializable value of type `T`. This value can be accessed by calling the `value` property. The variable will be sent to each node once and should be treated as read-only (updates will not be propagated to other nodes)[1, page 104-106]. If you broadcast the variable it will be distributed efficiently once per node.

Example by [2]: If you have huge array that is accessed from Spark Closures, for example some reference data, this array will be shipped to each spark node with closure. If you for example if you have 10 nodes cluster with 100 partitions (10 partitions per node), this Array will be distributed at least 100 times (10 times to each node).

```scala
val array: Array[Int] = ??? // some huge array
val broadcasted = sc.broadcast(array)
```

And some RDD

```scala
val rdd: RDD[Int] = ???
```

In this case array will be shipped with closure each time

```scala
rdd.map(i => array.contains(i))
```

and with broadcast you'll get huge performance benefit

```scala
rdd.map(i => broadcasted.value.contains(i))
```


## Example

In below assume `df` is a `pyspark.sql.DataFrame` the broadcast variable can be used in a udf.

```python
from pyspark.sql import functions as F
from pyspark.sql import types as T
from pyspark.sql import Row
from sklearn.neighbors import NearestNeighbors
from pyspark import SparkContext

sc = SparkContext.getOrCreate()

training = [[0, 0, 2], [1, 0, 0], [0, 0, 1]]
validation = [[0, 2, 2], [1, 0, 5], [1, 0, 1]]

neigh = NearestNeighbors(2, 0.4)
neigh.fit(training)
bc_neigh = sc.broadcast(neigh)

def kneighbors(x):
  """Returns the two closest neighbours.
  """
  return list(bc_neigh.value.kneighbors(x, 2, return_distance=False))

udf_kneighbors = F.udf(kneighbors, T.ArrayType(T.DoubleType))
df = (
  sc
  .parallelize([Row(x=x) for x in validation])
  .toDF()
  .withColumn(
        "knn",
        udf_kneighbors(x)
    )
)
```

In this small example we fit a NN model to the training data on the master node and then broadcast it out to each worker node to find the nearest neighbours for the samples in validation.


## References

[1] Holden Karau, Andy Konwinski, Patrick Wendell, Matei Zaharia, *Learning Spark: Lightning-Fast Big Data Analysis*. O'Reilly Media, 2015.

[2] [Ramana, What are broadcast variables? What problems do they solve?. Stackoverflow question 2014](https://stackoverflow.com/questions/26884871/what-are-broadcast-variables-what-problems-do-they-solve)

[3] [Umberto Griffo, When to use Broadcast variable. Blog Post.](https://umbertogriffo.gitbooks.io/apache-spark-best-practices-and-tuning/content/when_to_use_broadcast_variable.html)
