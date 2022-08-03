# Azure-PPML-Example-Occlum

## Prerequisites
You can pull the image from Dockerhub.
```bash
docker pull xiangyut/bigdl-ppml-azure-occlum:1.4
docker tag xiangyut/bigdl-ppml-azure-occlum:1.4 intelanalytics/bigdl-ppml-azure-occlum:2.1.0-SNAPSHOT
```
Or you can build image with `build-docker-image.sh`. Configure environment variables in `Dockerfile` and `build-docker-image.sh`.

Build the docker image:

```bash
bash build-docker-image.sh
```

## Run docker
```bash
docker run --rm -it \
    --name=azure-ppml-example-with-occlum \
    --device=/dev/sgx/enclave \
    --device=/dev/sgx/provision \
    intelanalytics/bigdl-ppml-azure-occlum:2.1.0-SNAPSHOT bash 
```

## SparkPi example
Run the SparkPi example with `run_spark_on_occlum_glibc.sh`.
```bash
cd /opt
bash run_spark_on_occlum_glibc.sh pi
```

## MAA example

You need to set environment variable `AZDCAP_DEBUG_LOG_LEVEL` first.
```bash
export AZDCAP_DEBUG_LOG_LEVEL=fatal
```

Run the sample code and get the Azure attestation token for doing Microsoft Azure Attestation in Occlum.
```bash
cd /opt
bash run_spark_on_occlum_glibc.sh maa
```
You should get the Azure attestation token when succeed.

## SparkPi on K8S
Configure environment variables in `run_spark_pi.sh`, `driver.yaml` and `executor.yaml`. Then you can submit SparkPi task with `run_spark_pi.sh`.
```bash
bash run_spark_pi.sh
```

## Known issues

- If you meet the following error when running the docker image:
```
aesm_service[10]: Failed to set logging callback for the quote provider library.
aesm_service[10]: The server sock is 0x5624fe742330
```
This may be associated with [SGX DCAP](https://github.com/intel/linux-sgx/issues/812). And it's expected error message if not all interfaces in quote provider library are valid, and will not cause a failure.

- If you meet the following error when running MAA example:
```
[get_platform_quote_cert_data ../qe_logic.cpp:352] p_sgx_get_quote_config returned NULL for p_pck_cert_config.
thread 'main' panicked at 'IOCTRL IOCTL_GET_DCAP_QUOTE_SIZE failed', /opt/src/occlum/tools/toolchains/dcap_lib/src/occlum_dcap.rs:70:13
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
[ERROR] occlum-pal: The init process exit with code: 101 (line 62, file src/pal_api.c)
[ERROR] occlum-pal: Failed to run the init process: EINVAL (line 150, file src/pal_api.c)
[ERROR] occlum-pal: Failed to do ECall: occlum_ecall_broadcast_interrupts with error code 0x2002: Invalid enclave identification. (line 26, file src/pal_interrupt_thread.c)
/opt/occlum/build/bin/occlum: line 337:  3004 Segmentation fault      (core dumped) RUST_BACKTRACE=1 "$instance_dir/build/bin/occlum-run" "$@"
```
This may be associated with [[RFC] IOCTRL IOCTL_GET_DCAP_QUOTE_SIZE failed](https://github.com/occlum/occlum/issues/899).