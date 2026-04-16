export OPENSSL_VERSION="openssl-4.0.0"
export OPENSSL_SHA256="c32cf49a959c4f345f9606982dd36e7d28f7c58b19c2e25d75624d2b3d2f79ac"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-zlib no-shared no-module no-comp no-apps no-docs no-sm2-precomp no-atexit"
export OPENSSL_BUILD_FLAGS_ARMV7L="linux-armv4 ${OPENSSL_BUILD_FLAGS_WINDOWS}"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
