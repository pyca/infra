export OPENSSL_VERSION="openssl-4.0.1"
export OPENSSL_SHA256="2db3f3a0d6ea4b59e1f094ace2c8cd536dffb87cdc39084c5afa1e6f7f37dd09"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-zlib no-shared no-module no-comp no-apps no-docs no-sm2-precomp no-atexit"
export OPENSSL_BUILD_FLAGS_ARMV7L="linux-armv4 ${OPENSSL_BUILD_FLAGS_WINDOWS}"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
