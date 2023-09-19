export OPENSSL_VERSION="openssl-3.1.3"
export OPENSSL_SHA256="f0316a2ebd89e7f2352976445458689f80302093788c466692fb2a188b2eacf6"
# We need a base set of flags because on Windows using MSVC
# enable-ec_nistp_64_gcc_128 doesn't work since there's no 128-bit type
export OPENSSL_BUILD_FLAGS_WINDOWS="no-ssl3 no-ssl3-method no-zlib no-shared no-module no-comp no-dynamic-engine"
export OPENSSL_BUILD_FLAGS="${OPENSSL_BUILD_FLAGS_WINDOWS} enable-ec_nistp_64_gcc_128"
