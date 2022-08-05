export HTTP_PROXY_HOST=child-prc.intel.com
export HTTP_PROXY_PORT=913
export HTTPS_PROXY_HOST=child-prc.intel.com
export HTTPS_PROXY_PORT=913

pushd nytaxi
mvn package 
popd

sudo docker build \
    --build-arg http_proxy=http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT \
    --build-arg https_proxy=http://$HTTPS_PROXY_HOST:$HTTPS_PROXY_PORT \
    --build-arg HTTP_PROXY_HOST=$HTTP_PROXY_HOST \
    --build-arg HTTP_PROXY_PORT=$HTTP_PROXY_PORT \
    --build-arg HTTPS_PROXY_HOST=$HTTPS_PROXY_HOST \
    --build-arg HTTPS_PROXY_PORT=$HTTPS_PROXY_PORT \
    -t intelanalytics/bigdl-ppml-azure-occlum:2.1.0-SNAPSHOT -f ./Dockerfile .
