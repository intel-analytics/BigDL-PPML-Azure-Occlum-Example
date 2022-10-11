# Clean up old container
export container_name=bigdl-ppml-trusted-big-data-ml-scala-occlum-build
export image_name=xiangyut/bigdl-ppml-azure-occlum:mount1
export final_name=xiangyut/bigdl-ppml-azure-occlum:final
sudo docker rm -f $container_name

# Run new command in container
sudo docker run -it \
        --net=host \
        --name=$container_name \
        --cpuset-cpus 3-5 \
        -e LOCAL_IP=$LOCAL_IP \
        -e SGX_MEM_SIZE=12GB \
        -e SGX_THREAD=2048 \
        -e SGX_HEAP=1GB \
        -e SGX_KERNEL_HEAP=1GB \
        -e PCCS_URL=$PCCS_URL \
        -e ATTESTATION=false \
        -e ATTESTATION_SERVER_IP=$ATTESTATION_SERVER_IP \
        -e ATTESTATION_SERVER_PORT=$ATTESTATION_SERVER_PORT \
        $image_name \
        bash /opt/run_spark_on_occlum_glibc.sh init
echo "build finish"
docker commit $container_name $final_name
