export OPENSSL_VERSION="openssl-3.5.2"
export OPENSSL_SHA256="c53a47e5e441c930c3928cf7bf6fb00e5d129b630e0aa873b08258656e7345ec"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-ssl3 no-ssl3-method no-zlib no-shared no-module no-comp no-dynamic-engine no-apps no-docs no-sm2-precomp no-atexit"
export OPENSSL_BUILD_FLAGS_ARMV7L="linux-armv4 ${OPENSSL_BUILD_FLAGS_WINDOWS}"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
