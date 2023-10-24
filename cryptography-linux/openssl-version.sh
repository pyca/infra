export OPENSSL_VERSION="openssl-3.1.4"
export OPENSSL_SHA256="840af5366ab9b522bde525826be3ef0fb0af81c6a9ebd84caa600fea1731eee3"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-ssl3 no-ssl3-method no-zlib no-shared no-module no-comp no-dynamic-engine"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
