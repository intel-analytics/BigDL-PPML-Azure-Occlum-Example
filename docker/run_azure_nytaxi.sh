#!/bin/bash

$SPARK_HOME/bin/spark-submit \
  --class AzureNytaxi \
  --master local[8] \
  spark-azure-nytaxi-1.0-SNAPSHOT.jar 
