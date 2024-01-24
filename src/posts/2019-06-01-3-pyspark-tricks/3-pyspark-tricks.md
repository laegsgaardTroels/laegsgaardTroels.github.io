Some useful patterns / tricks I find myself using at work.<!--more-->

## Union after loop

Sometimes it is usefull to append DataFrame's in a list and union them back together afterwards.

```python
from pyspark.sql import DataFrame
from functools import reduce

shell = []
for i in range(M):
    df = ...
    shell.append(df)

res = reduce(DataFrame.unionAll, shell)
```

Each df in the loop has the same schema. Note that `.unionAll` and `.union` are equivalent, but `.unionAll` is more explicit.

## Use a Broadcast variable in a UDF

A broadcast variable is useful too look up values, the values in a broadcast variable can be accessed using the `.value` attribute in a udf.

```python
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql import types as T

spark = SparkSession.builder.getOrCreate()

foo = {
    'a': 'b',
}
bc_foo = spark.sparkContext.broadcast(foo)

def _look_up(x):
    foo_ = bc_foo.value
    return foo_[x]    

udf_calculate = F.udf(_look_up, T.DoubleType())
```

## Return Multiple Outputs from a UDF

A UDF can return multiple values if one return af StructType.

```python
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from pyspark.sql import types as T

def _calculate(x):
    ...    
    return x, y, z

schema = T.StructType([
    T.StructField("x", T.DoubleType(),
    T.StructField("y", T.DoubleType(),
    T.StructField("z", T.DoubleType(),
])
udf_multiple_results = F.udf(_calculate, schema)
```

This UDF will take one input x and return a nested column with three fields called x, y, z. Can be accessed using:

```python
df = (
    df
    .withColumn(
        "nested_column",
        udf_multiple_results('x')
    )
    .select(
        F.col('nested_column.x').alias('x'),
        F.col('nested_column.y').alias('y'),
        F.col('nested_column.z').alias('z'),
    )
)
```

And flattened using

```python
df = df.select('nested_column.*')
```
