#!/bin/bash

${SPARK_HOME}/bin/spark-submit \
    --master  k8s://https://${kubernetes_master_url}:${k8s_apiserver_port} \
    --deploy-mode cluster \
    --name spark-nytaxi \
    --class AzureNytaxi \
    --driver-cores 4 \
    --executor-cores 4 \
    --conf spark.executor.instances=1 \
    --conf spark.rpc.netty.dispatcher.numThreads=128 \
    --conf spark.kubernetes.container.image=intelanalytics/bigdl-ppml-azure-occlum:2.1.0-SNAPSHOT \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.executor.deleteOnTermination=false \
    --conf spark.kubernetes.driver.podTemplateFile=./driver.yaml \
    --conf spark.kubernetes.executor.podTemplateFile=./executor.yaml \
    --conf spark.kubernetes.sgx.log.level=off \
    local:/bin/jars/spark-azure-nytaxi-1.0-SNAPSHOT.jar

