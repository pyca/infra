export OPENSSL_VERSION="openssl-3.3.1"
export OPENSSL_SHA256="777cd596284c883375a2a7a11bf5d2786fc5413255efab20c50d6ffe6d020b7e"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-ssl3 no-ssl3-method no-zlib no-shared no-module no-comp no-dynamic-engine no-apps no-docs no-sm2-precomp no-atexit"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
