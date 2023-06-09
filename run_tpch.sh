#set -
BIGDL_VERSION=2.1.0
SPARK_EXTRA_JAR_PATH=/bin/jars/bigdl-ppml-spark_3.1.2-${BIGDL_VERSION}.jar
SPARK_JOB_MAIN_CLASS=com.intel.analytics.bigdl.ppml.examples.tpch.TpchQuery
IMAGE=intelanalytics/bigdl-ppml-azure-occlum:2.1.0

KEY_VAULT_NAME=
DATA_LAKE_NAME=
DATA_LAKE_ACCESS_KEY=
FS_PATH=abfs://xxx@${DATA_LAKE_NAME}.dfs.core.windows.net
INPUT_DIR_PATH=$FS_PATH/dbgen/dbgen-encrypted-1g
ENCRYPT_KEYS_PATH=$FS_PATH/keys
OUTPUT_DIR_PATH=$FS_PATH/dbgen/out-dbgen-1g

export kubernetes_master_url=

${SPARK_HOME}/bin/spark-submit \
    --master k8s://https://${kubernetes_master_url} \
    --deploy-mode cluster \
    --name spark-tpch \
    --conf spark.rpc.netty.dispatcher.numThreads=32 \
    --conf spark.kubernetes.container.image=${IMAGE} \
    --conf spark.kubernetes.authenticate.driver.serviceAccountName=spark \
    --conf spark.kubernetes.executor.deleteOnTermination=false \
    --conf spark.kubernetes.driver.podTemplateFile=./driver.yaml \
    --conf spark.kubernetes.executor.podTemplateFile=./executor.yaml \
    --conf spark.kubernetes.file.upload.path=file:///tmp \
    --conf spark.kubernetes.sgx.log.level=error \
    --conf spark.kubernetes.driverEnv.DRIVER_MEMORY=2g \
    --conf spark.kubernetes.driverEnv.SGX_MEM_SIZE="25GB" \
    --conf spark.kubernetes.driverEnv.META_SPACE=1024M \
    --conf spark.kubernetes.driverEnv.SGX_HEAP="1GB" \
    --conf spark.kubernetes.driverEnv.SGX_KERNEL_HEAP="2GB" \
    --conf spark.kubernetes.driverEnv.SGX_THREAD="1024" \
    --conf spark.kubernetes.driverEnv.FS_TYPE="hostfs" \
    --conf spark.executorEnv.SGX_MEM_SIZE="16GB" \
    --conf spark.executorEnv.SGX_KERNEL_HEAP="2GB" \
    --conf spark.executorEnv.SGX_HEAP="1GB" \
    --conf spark.executorEnv.SGX_THREAD="1024" \
    --conf spark.executorEnv.SGX_EXECUTOR_JVM_MEM_SIZE="7G" \
    --conf spark.kubernetes.driverEnv.SGX_DRIVER_JVM_MEM_SIZE="1G" \
    --conf spark.executorEnv.FS_TYPE="hostfs" \
    --num-executors 1  \
    --executor-cores 4 \
    --executor-memory 3g \
    --driver-cores 4 \
    --conf spark.cores.max=4 \
    --conf spark.driver.defaultJavaOptions="-Dlog4j.configuration=/opt/spark/conf/log4j2.xml" \
    --conf spark.executor.defaultJavaOptions="-Dlog4j.configuration=/opt/spark/conf/log4j2.xml" \
    --conf spark.network.timeout=10000000 \
    --conf spark.executor.heartbeatInterval=10000000 \
    --conf spark.python.use.daemon=false \
    --conf spark.python.worker.reuse=false \
    --conf spark.sql.auto.repartition=true \
    --conf spark.default.parallelism=400 \
    --conf spark.sql.shuffle.partitions=400 \
    --conf spark.hadoop.fs.azure.account.auth.type.${DATA_LAKE_NAME}.dfs.core.windows.net=SharedKey \
    --conf spark.hadoop.fs.azure.account.key.${DATA_LAKE_NAME}.dfs.core.windows.net=${DATA_LAKE_ACCESS_KEY} \
    --conf spark.hadoop.fs.azure.enable.append.support=true \
    --conf spark.bigdl.kms.type=AzureKeyManagementService \
    --conf spark.bigdl.kms.azure.vault=${KEY_VAULT_NAME} \
    --conf spark.bigdl.kms.key.primary=$ENCRYPT_KEYS_PATH/primaryKey \
    --conf spark.bigdl.kms.key.data=$ENCRYPT_KEYS_PATH/dataKey \
    --class $SPARK_JOB_MAIN_CLASS \
    --verbose \
    local:$SPARK_EXTRA_JAR_PATH \
    $INPUT_DIR_PATH \
    $OUTPUT_DIR_PATH \
    AES/CBC/PKCS5Padding \
    plain_text