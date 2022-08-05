#!/bin/bash

$SPARK_HOME/bin/spark-submit \
  --class SimpleQuery \
  --master local[8] \
  spark-simple-query-1.0-SNAPSHOT.jar 
