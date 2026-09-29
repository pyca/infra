export OPENSSL_VERSION="openssl-4.0.3"
export OPENSSL_SHA256="325b5c806167c13b40b1ffeadfe0248197c00eccc4cf123ec1e28d2d2fd216d9"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-zlib no-shared no-module no-comp no-apps no-docs no-sm2-precomp no-atexit"
export OPENSSL_BUILD_FLAGS_ARMV7L="linux-armv4 ${OPENSSL_BUILD_FLAGS_WINDOWS}"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
