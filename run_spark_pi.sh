#!/bin/bash
IMAGE=intelanalytics/bigdl-ppml-azure-occlum:2.1.0
${SPARK_HOME}/bin/spark-submit \
    --master k8s://https://${kubernetes_master_url}:${k8s_apiserver_port} \
    --deploy-mode cluster \
    --name spark-pi \
    --class org.apache.spark.examples.SparkPi \
    --conf spark.executor.instances=1 \
    --conf spark.rpc.netty.dispatcher.numThreads=32 \
    --conf spark.kubernetes.container.image=${IMAGE} \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.executor.deleteOnTermination=false \
    --conf spark.kubernetes.driver.podTemplateFile=./driver.yaml \
    --conf spark.kubernetes.executor.podTemplateFile=./executor.yaml \
    --conf spark.kubernetes.sgx.log.level=off \
    --conf spark.executorEnv.SGX_EXECUTOR_JVM_MEM_SIZE="1g" \
    --conf spark.kubernetes.driverEnv.SGX_DRIVER_JVM_MEM_SIZE="1g" \
    local:/opt/spark/examples/jars/spark-examples_2.12-3.1.2.jar
