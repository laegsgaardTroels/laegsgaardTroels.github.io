---
author: "Troels L\xE6gsgaard"
category: Programming
code: ''
content: ''
date: '2019-12-04'
day: '04'
excerpt: 'The pipeline object in sklearn makes it easy to sequentially apply a list
  of transforms and a final estimator [1]. This makes it easy to organize models.

  PySpark has a similar pipeline API but there are some differences. [...]'
image: /assets/images/2019-12-04-difference-between-the-sklearn-pipeline-and-the-pyspark-pipeline/pipeline.jpg
month: '12'
title: Difference Between The Pyspark Pipeline And The Sklearn Pipeline
url: /posts/2019-12-04-difference-between-the-pyspark-pipeline-and-the-sklearn-pipeline.html
year: '2019'
---

The pipeline object in sklearn makes it easy to sequentially apply a list of transforms and a final estimator [1]. This makes it easy to organize models.
PySpark has a similar pipeline API but there are some differences.<!--more-->

1. There are a `.fit()` and `.transform()` method, they work in the same way in sklearn but on the `pyspark.sql.DataFrame`, but there are  no `.predict()` method.
2. You can specify the subset of input features in a pipeline. E.g. you don't have to apply the model to *all* the columns in a dataframe `X` but you can do with a subset.
3. Similar with the response variable can be specified as a column in the dataframe.
4. When predicting you use the `.transform()` method on a fitted model object, which adds extra column(s) based on the model.
5. The input features are `Vector` object, You usually use the `VectorAssembler` in the first step of the pipeline to assemble input features into this object.

Sample code snippet:

```python
from pyspark.ml import Pipeline
from pyspark.ml import PipelineModel
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.regression import RandomForestRegressor


assembler = VectorAssembler(
    inputCols=feature_cols,
    outputCol="features"
)

rf = RandomForestRegressor(
    featuresCol="features",
    labelCol=response_variable,
    predictionCol="prediction",
    **parameters
)

pipeline = Pipeline(stages=[assembler, rf])
model = pipeline.fit(train)
test_with_predictions = model.predict(test)  # This will add a `prediction` column AND a `features` column to test.

# Save the model for later use.
model.write().overwrite().save('/tmp/my_great_model')

# Load the model later.
model = PipelineModel.load('/tmp/my_great_model')
```

The added `features` column is added from the `VectorAssembler`.


## References

[1] [Sklearn pipeline docs](https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html)

[2] [Spark pipeline docs](https://spark.apache.org/docs/latest/ml-pipeline.html)
