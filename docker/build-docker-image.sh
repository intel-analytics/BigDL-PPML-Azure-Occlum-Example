export HTTP_PROXY_HOST=your_http_proxy_host
export HTTP_PROXY_PORT=your_http_proxy_port
export HTTPS_PROXY_HOST=your_https_proxy_host
export HTTPS_PROXY_PORT=your_https_proxy_port
export AZURE_BLOB_ACCOUNT_NAME=azureopendatastorage
export AZURE_BLOB_CONTAINER_NAME=nyctlc
export AZURE_BLOB_RELATIVE_PATH=yellow
export AZURE_BLOB_SAS_TOKEN=r

cd ../nytaxi
mvn clean package 
cd ../docker
cp ../nytaxi/target/spark-azure-nytaxi-1.0-SNAPSHOT-jar-with-dependencies.jar ./

export container_name=bigdl-ppml-trusted-big-data-ml-scala-occlum-build
export image_name=intelanalytics/bigdl-ppml-azure-occlum:2.1.0-SNAPSHOT
export final_name=intelanalytics/bigdl-ppml-azure-occlum:2.1.0

sudo docker build \
    --build-arg http_proxy=http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT \
    --build-arg https_proxy=http://$HTTPS_PROXY_HOST:$HTTPS_PROXY_PORT \
    --build-arg HTTP_PROXY_HOST=$HTTP_PROXY_HOST \
    --build-arg HTTP_PROXY_PORT=$HTTP_PROXY_PORT \
    --build-arg HTTPS_PROXY_HOST=$HTTPS_PROXY_HOST \
    --build-arg HTTPS_PROXY_PORT=$HTTPS_PROXY_PORT \
    --build-arg AZURE_BLOB_ACCOUNT_NAME=$AZURE_BLOB_ACCOUNT_NAME \
    --build-arg AZURE_BLOB_CONTAINER_NAME=$AZURE_BLOB_CONTAINER_NAME \
    --build-arg AZURE_BLOB_RELATIVE_PATH=$AZURE_BLOB_RELATIVE_PATH \
    --build-arg AZURE_BLOB_SAS_TOKEN=$AZURE_BLOB_SAS_TOKEN \
    --build-arg AZURE_SQL_AE_JDBC=$AZURE_SQL_AE_JDBC \
    -t $image_name -f ./Dockerfile .

bash occlum-build.sh -c $container_name -i $image_name -f $final_name
