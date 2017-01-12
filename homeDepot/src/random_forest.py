import os
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext
import numpy as np
from pyspark.ml import Pipeline
from pyspark.ml.classification import RandomForestClassifier
from pyspark.ml.feature import StringIndexer, VectorIndexer
from pyspark.sql import functions as F
from pyspark.sql.functions import lit
from pyspark.sql.types import *
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.linalg import Vectors
from pyspark.ml.tuning import ParamGridBuilder, CrossValidator
from pyspark.ml.evaluation import RegressionEvaluator
from pyspark.ml.regression import RandomForestRegressor

# Build the Spark Context

conf = SparkConf().setAppName('ML - Final Project').setMaster('local')
sc = SparkContext(conf=conf)
sqlContext = SQLContext(sc)

trainFile = 'E:/Ranjani/Docs/sem5/PROJECT/OurProject/trainingFeatures.csv'
testFile =  'E:/Ranjani/Docs/sem5/PROJECT/OurProject/testFeatures.csv'

#Create schema

data_df_schema = StructType(
	[StructField('x0', DoubleType()),
	 StructField('x1', DoubleType()),
	 StructField('x2', DoubleType()),
	 StructField('x3', DoubleType()),
	 StructField('x4', DoubleType())]
)

data_test_df_schema = StructType(
	[StructField('x0', DoubleType()),
	 StructField('x1', DoubleType()),
	 StructField('x2', DoubleType()),
	 StructField('x3', DoubleType())]	 
)

# Loading train and test data
trainDF = sqlContext.read.format('com.databricks.spark.csv').options(header=False, inferSchema=False).schema(data_df_schema).load(trainFile)
testDF = sqlContext.read.format('com.databricks.spark.csv').options(header=False, inferSchema=False).schema(data_test_df_schema).load(testFile)
testDF = testDF.withColumn('x4', lit(0.0))

# Vector Assembler


assembler  = VectorAssembler(
	inputCols=['x0', 'x1', 'x2', 'x3'],
	outputCol="features")

trainDF = assembler.transform(trainDF)
testDF = assembler.transform(testDF)
# Create the indexers

#labelIndexer = StringIndexer(inputCol="x4", outputCol="indexedLabel").fit(trainDF)


# Create Feature indexers
featureIndexer = VectorIndexer(inputCol="features", outputCol="indexedFeatures", maxCategories=4).fit(trainDF)
featIndexer = VectorIndexer(inputCol="features", outputCol="indexedFeatures", maxCategories=4).fit(testDF)

(trainingData, testData) = trainDF.randomSplit([0.8, 0.2])
# Building a RF model

rf = RandomForestRegressor(labelCol="x4", featuresCol="indexedFeatures",numTrees=3, maxDepth=29, maxBins=32, featureSubsetStrategy="auto")

# Pipeline

pipeline = Pipeline(stages=[featureIndexer, rf])

# Cross Validation

paramGrid = ParamGridBuilder().build()

evaluator = RegressionEvaluator(predictionCol="prediction", labelCol="x4",metricName="rmse")
evaluator2 = RegressionEvaluator(predictionCol="prediction", labelCol="x4",metricName="r2")

cv = CrossValidator(estimator=pipeline, estimatorParamMaps=paramGrid, evaluator=evaluator, numFolds=5) # 5 fold CV

cvModel = cv.fit(trainDF)
cvModel1 = cv.fit(trainingData)

predict = cvModel.transform(testDF)
file1 = open('predictionFile.txt','w')
predict.select("prediction").show(10)
file1.write('\n'.join(list(map(str,predict.select("prediction").collect()))))

predict_cv = cvModel1.transform(testData)

rmse = evaluator.evaluate(predict_cv)

print("Root Mean Squared Error (RMSE) on test data = %g" % rmse)

file2 = open('outputFile.txt','w')
file2.write("Root Mean Squared Error (RMSE) on test data = %g" % rmse)

file1.close()
file2.close()