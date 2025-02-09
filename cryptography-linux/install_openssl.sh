#!/bin/bash
set -xe

OPENSSL_URL="https://github.com/openssl/openssl/releases/download"
source /root/openssl-version.sh

curl -#LO "${OPENSSL_URL}/${OPENSSL_VERSION}/${OPENSSL_VERSION}.tar.gz"
echo "${OPENSSL_SHA256}  ${OPENSSL_VERSION}.tar.gz" | sha256sum -c -
tar zxf ${OPENSSL_VERSION}.tar.gz
pushd ${OPENSSL_VERSION}
BUILD_FLAGS="$OPENSSL_BUILD_FLAGS"
# Can't use `$(uname -m) = "armv7l"` because that returns what kernel we're
# using, and we build for armv7l with an ARM64 host.
if [ "$(readelf -h /proc/self/exe | grep -o 'Machine:.* ARM')" ]; then
    BUILD_FLAGS="$OPENSSL_BUILD_FLAGS_ARMV7L"
fi
./config $BUILD_FLAGS --prefix=/opt/pyca/cryptography/openssl --openssldir=/opt/pyca/cryptography/openssl
make depend
make -j4
# avoid installing the docs
# https://github.com/openssl/openssl/issues/6685#issuecomment-403838728
make install_sw install_ssldirs
popd
rm -rf openssl*
