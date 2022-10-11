export OPENSSL_VERSION="openssl-3.0.6"
export OPENSSL_SHA256="e4a10a2986945e3f1a1f2ebd68ac780449a1773b96b6a174fdf650d6bc9611f1"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-ssl3 no-ssl3-method no-zlib no-shared no-module no-comp no-dynamic-engine"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
