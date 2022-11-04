FROM intelanalytics/bigdl-ppml-trusted-big-data-ml-scala-occlum:2.1.0 as ppml

ARG BIGDL_VERSION=2.1.0
ARG HTTP_PROXY_HOST
ARG HTTP_PROXY_PORT
ARG HTTPS_PROXY_HOST
ARG HTTPS_PROXY_PORT
ARG AZURE_BLOB_ACCOUNT_NAME
ARG AZURE_BLOB_CONTAINER_NAME
ARG AZURE_BLOB_RELATIVE_PATH
ARG AZURE_BLOB_SAS_TOKEN
ARG AZURE_SQL_AE_JDBC

ENV BIGDL_VERSION=${BIGDL_VERSION}
ENV HTTP_PROXY=http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT
ENV HTTPS_PROXY=http://$HTTPS_PROXY_HOST:$HTTPS_PROXY_PORT
ENV AZURE_BLOB_ACCOUNT_NAME=$AZURE_BLOB_ACCOUNT_NAME
ENV AZURE_BLOB_CONTAINER_NAME=$AZURE_BLOB_CONTAINER_NAME
ENV AZURE_BLOB_RELATIVE_PATH=$AZURE_BLOB_RELATIVE_PATH
ENV AZURE_BLOB_SAS_TOKEN=$AZURE_BLOB_SAS_TOKEN
ENV AZURE_SQL_AE_JDBC=$AZURE_SQL_AE_JDBC

ENV AZDCAP_DEBUG_LOG_LEVEL=fatal

RUN mkdir -p /opt/src && \
    cd /opt/src && \
    git clone https://github.com/occlum/occlum.git && \
    cd occlum && \
    apt purge libsgx-dcap-default-qpl -y

RUN echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" | sudo tee /etc/apt/sources.list.d/msprod.list && \
    wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
    apt update && \
    apt install az-dcap-client tree

RUN cd /opt/src/occlum && \
    git submodule update --init 

RUN wget -P /opt/spark/jars/ https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.2.0/hadoop-azure-3.2.0.jar && \
    wget -P /opt/spark/jars/ https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure-datalake/3.2.0/hadoop-azure-datalake-3.2.0.jar && \
    wget -P /opt/spark/jars/ https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/7.0.0/azure-storage-7.0.0.jar && \
    wget -P /opt/spark/jars/ https://repo1.maven.org/maven2/com/microsoft/azure/azure-data-lake-store-sdk/2.2.9/azure-data-lake-store-sdk-2.2.9.jar && \
    wget -P /opt/spark/jars/ https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util-ajax/9.3.24.v20180605/jetty-util-ajax-9.3.24.v20180605.jar && \
    wget -P /opt/spark/jars/ https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/9.3.24.v20180605/jetty-util-9.3.24.v20180605.jar && \
    wget -P /opt/spark/jars/ https://repo1.maven.org/maven2/org/wildfly/openssl/wildfly-openssl/1.0.7.Final/wildfly-openssl-1.0.7.Final.jar

RUN rm /opt/run_spark_on_occlum_glibc.sh && \
    rm /opt/entrypoint.sh && \
    rm -rf /opt/spark-source

ADD ./run_spark_on_occlum_glibc.sh /opt/run_spark_on_occlum_glibc.sh
ADD ./entrypoint.sh /opt/entrypoint.sh
ADD ./mount.sh /opt/mount.sh
ADD ./add_conf.sh /opt/occlum_spark/add_conf.sh

RUN cp /opt/run_spark_on_occlum_glibc.sh /root/run_spark_on_occlum_glibc.sh

RUN cd /opt/src/occlum/demos/remote_attestation/azure_attestation/maa_init/init && \
    cargo clean && \
    cargo build --release 

RUN chmod a+x /opt/entrypoint.sh && \
    chmod a+x /opt/run_spark_on_occlum_glibc.sh && \
    chmod a+x /root/run_spark_on_occlum_glibc.sh && \
    chmod a+x /opt/mount.sh && \
    chmod a+x /opt/occlum_spark/add_conf.sh

ADD ./spark-azure-nytaxi-1.0-SNAPSHOT-jar-with-dependencies.jar /root/spark-azure-nytaxi-1.0-SNAPSHOT.jar
RUN cp /root/spark-azure-nytaxi-1.0-SNAPSHOT.jar /opt/bigdl-${BIGDL_VERSION}/jars/
ADD ./run_azure_nytaxi.sh /root/run_azure_nytaxi.sh
ADD ./run_spark_pi.sh /root/run_spark_pi.sh
ADD ./run_nytaxi_k8s.sh /root/run_nytaxi_k8s.sh
ADD ./driver.yaml /root/driver.yaml
ADD ./executor.yaml /root/executor.yaml

# install azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ENTRYPOINT [ "/opt/entrypoint.sh" ]
