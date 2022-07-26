# Azure-PPML-Example-Occlum

## Prerequisites

You can build image with `build-docker-image.sh`. Configure environment variables in `Dockerfile` and `build-docker-image.sh`.

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
    -v /var/run/aesmd:/var/run/aesmd \
    intelanalytics/bigdl-ppml-azure-occlum:2.1.0-SNAPSHOT bash 
```

## Spark example
TODO

## MAA example

You need to set environment variable `AZDCAP_DEBUG_LOG_LEVEL` first.
```bash
export AZDCAP_DEBUG_LOG_LEVEL=Fatal
```

Run the sample code and get the Azure attestation token for doing Microsoft Azure Attestation in Occlum.
```bash
cd /opt/src/occlum/demos/remote_attestation/azure_attestation/maa_init/occlum_instance
occlum run /bin/busybox cat /root/token
```
You can also get the base64 quote by the following command:
```bash
occlum run /bin/busybox cat /root/quote_base64
```

## Known issues

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