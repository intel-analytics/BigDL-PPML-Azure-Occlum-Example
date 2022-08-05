export HTTP_PROXY_HOST=child-prc.intel.com
export HTTP_PROXY_PORT=913
export HTTPS_PROXY_HOST=child-prc.intel.com
export HTTPS_PROXY_PORT=913
export AZURE_BLOB_ACCOUNT_NAME=azureopendatastorage
export AZURE_BLOB_CONTAINER_NAME=nyctlc
export AZURE_BLOB_RELATIVE_PATH=yellow
export AZURE_BLOB_SAS_TOKEN=r

pushd nytaxi
mvn clean package 
popd

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
    -t intelanalytics/bigdl-ppml-azure-occlum:2.1.0-SNAPSHOT -f ./Dockerfile .
