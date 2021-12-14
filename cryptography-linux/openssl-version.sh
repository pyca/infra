export OPENSSL_VERSION="openssl-1.1.1m"
export OPENSSL_SHA256="f89199be8b23ca45fc7cb9f1d8d3ee67312318286ad030f5316aca6462db6c96"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-ssl3 no-ssl3-method no-zlib no-shared no-comp no-dynamic-engine"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
