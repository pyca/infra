#!/bin/bash
set -xe

LIBFFI_SHA256="d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37"
LIBFFI_VERSION="3.2.1"

function check_sha256sum {
    local fname=$1
    local sha256=$2
    echo "${sha256}  ${fname}" > "${fname}.sha256"
    sha256sum -c "${fname}.sha256"
    rm "${fname}.sha256"
}

curl -#O "https://mirrors.ocf.berkeley.edu/debian/pool/main/libf/libffi/libffi_${LIBFFI_VERSION}.orig.tar.gz"
check_sha256sum "libffi_${LIBFFI_VERSION}.orig.tar.gz" ${LIBFFI_SHA256}
tar zxf libffi*.orig.tar.gz
PATH=/opt/perl/bin:$PATH
cd libffi*
echo "Configuring for x86_64"
# CFLAGS needed to override the Makefile and prevent -march optimization
# This flag set taken from Ubuntu 14.04's defaults. We should update it
# to use -fstack-protector-strong if/when gcc 4.9+ is added to the
# manylinux1 images.
./configure CFLAGS="-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security"
make install
