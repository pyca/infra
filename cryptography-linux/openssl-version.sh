export OPENSSL_VERSION="openssl-3.0.7"
export OPENSSL_SHA256="83049d042a260e696f62406ac5c08bf706fd84383f945cf21bd61e9ed95c396e"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-ssl3 no-ssl3-method no-zlib no-shared no-module no-comp no-dynamic-engine"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
