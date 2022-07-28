FROM intelanalytics/bigdl-ppml-trusted-big-data-ml-scala-occlum:2.1.0-SNAPSHOT as ppml

ARG HTTP_PROXY_HOST
ARG HTTP_PROXY_PORT
ARG HTTPS_PROXY_HOST
ARG HTTPS_PROXY_PORT
ENV HTTP_PROXY=http://$HTTP_PROXY_HOST:$HTTP_PROXY_PORT
ENV HTTPS_PROXY=http://$HTTPS_PROXY_HOST:$HTTPS_PROXY_PORT

RUN mkdir -p /opt/src && \
    cd /opt/src && \
    git clone https://github.com/qzheng527/occlum.git && \
    cd occlum && \
    git checkout maa_init && \
    apt purge libsgx-dcap-default-qpl -y

RUN echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/20.04/prod focal main" | sudo tee /etc/apt/sources.list.d/msprod.list && \
    wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - && \
    apt update && \
    apt install az-dcap-client tree

RUN cd /opt/src/occlum && \
    git submodule update --init 

RUN rm /opt/run_spark_on_occlum_glibc.sh

ADD ./run_spark_on_occlum_glibc.sh /opt/run_spark_on_occlum_glibc.sh
ADD ./Cargo.toml /root/Cargo.toml 

RUN cp /root/Cargo.toml /opt/src/occlum/demos/remote_attestation/azure_attestation/maa_init/init/Cargo.toml && \
    cp /opt/run_spark_on_occlum_glibc.sh /root/run_spark_on_occlum_glibc.sh 
