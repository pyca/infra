ARG NODE24_ARCH_RELEASE
FROM ghcr.io/pyca/static-nodejs-${NODE24_ARCH_RELEASE} AS staticnodejs24

FROM alpine:latest

# Increment this to blow away the docker cache
ENV CACHE_BUSTER=1

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG=C.UTF-8

# Remove things nothing in CI uses: the static libpython (~100MB), gcc's LTO
# backend and the sanitizer runtimes.
RUN apk add --no-cache git libffi-dev curl \
    python3-dev openssl-dev bash gcc musl-dev tar pkgconfig zstd make rustup && \
    rm -f /usr/lib/python3*/config-*/libpython*.a \
        /usr/libexec/gcc/*/*/lto1 /usr/bin/lto-dump \
        /usr/lib/libasan* /usr/lib/libhwasan* /usr/lib/liblsan* /usr/lib/libtsan* /usr/lib/libubsan*

COPY --from=staticnodejs24 /out/ /staticnode/24/

# We only need llvm-profdata and llvm-cov from llvm-tools-preview (for rust
# coverage); on musl every tool is statically linked and huge, so drop the
# rest, strip the big binaries (with llvm-strip; GNU strip breaks them), and
# drop rust-lld too (rustc uses the system linker on musl).
RUN rustup-init -y --default-toolchain stable --profile minimal --component llvm-tools-preview && \
    rm -rf /root/.rustup/toolchains/*/share/doc /root/.rustup/toolchains/*/share/man && \
    sysroot="$(/root/.cargo/bin/rustc --print sysroot)" && \
    host="$(/root/.cargo/bin/rustc -vV | sed -n 's/^host: //p')" && \
    cd "$sysroot/lib/rustlib/$host" && \
    for f in "$sysroot/bin/cargo" "$sysroot/bin/rustc" \
             "$sysroot"/lib/librustc_driver-*.so \
             bin/llvm-cov bin/llvm-profdata; do \
        if [ -f "$f" ]; then bin/llvm-strip --strip-all "$f"; fi; \
    done && \
    for f in $(sed -n "s|^file:lib/rustlib/$host/bin/||p" "$sysroot/lib/rustlib/manifest-llvm-tools-preview-$host"); do \
        case "$f" in llvm-cov|llvm-profdata) ;; *) rm "bin/$f" ;; esac; \
    done && \
    rm -f lib/librustc-stable_rt.*.a bin/wasm-component-ld bin/rust-lld
ENV PATH="/root/.cargo/bin:$PATH"

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir
