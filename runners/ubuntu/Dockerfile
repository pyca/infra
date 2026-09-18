ARG RELEASE
FROM ubuntu:${RELEASE}

# Increment this to blow away the docker cache
ENV CACHE_BUSTER=3

ENV DEBIAN_FRONTEND=noninteractive

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG=C.UTF-8

# Don't unpack things nothing in CI uses: static libpython and OpenSSL, gcc's
# LTO backend, and the sanitizer runtimes (hard deps of libgcc-dev).
RUN printf '%s\n' \
    'path-exclude=/usr/lib/python3*/config-*/libpython*.a' \
    'path-exclude=/usr/lib/*/libcrypto.a' \
    'path-exclude=/usr/lib/*/libssl.a' \
    'path-exclude=/usr/libexec/gcc/*/*/lto1' \
    'path-exclude=/usr/bin/*-lto-dump-*' \
    'path-exclude=/usr/lib/*/libasan*' \
    'path-exclude=/usr/lib/*/libhwasan*' \
    'path-exclude=/usr/lib/*/liblsan*' \
    'path-exclude=/usr/lib/*/libtsan*' \
    'path-exclude=/usr/lib/*/libubsan*' \
    'path-exclude=/usr/lib/gcc/*/*/libasan*' \
    'path-exclude=/usr/lib/gcc/*/*/libhwasan*' \
    'path-exclude=/usr/lib/gcc/*/*/liblsan*' \
    'path-exclude=/usr/lib/gcc/*/*/libtsan*' \
    'path-exclude=/usr/lib/gcc/*/*/libubsan*' \
    > /etc/dpkg/dpkg.cfg.d/excludes-unused-dev-files

# We only need a C compiler and linker for cffi/cc-rs, not all of
# build-essential (g++, make, dpkg-dev, ...), and none of the recommended
# packages (openssh-client, gnupg, less, patch, ...).
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libc6-dev \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-venv \
    git \
    ca-certificates \
    curl \
    tzdata \
    pkg-config \
    zstd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# If we're on 32-bit ARM (which we can't check with `uname -m`, because we're
# usually on an arm64 host), install arm64 libc/c++. This is so that when
# Github Actions injects an arm64 node binary into the container, it can find
# the dynamic linker.
RUN if [ "$(readelf -h /proc/self/exe | grep -o 'Machine:.* ARM')" ]; \
    then \
        dpkg --add-architecture arm64; \
        apt-get update; \
        apt-get install -y --no-install-recommends libc6:arm64 libstdc++6:arm64; \
        apt-get clean; \
        rm -rf /var/lib/apt/lists; \
    fi

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir

# We only need llvm-profdata and llvm-cov from llvm-tools-preview (for rust
# coverage). Its libLLVM.so is identical to rustc's, so symlink it, then strip
# the big binaries (with llvm-strip; GNU strip breaks them) and drop the rest.
RUN curl -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh && \
    sh /tmp/rustup-init.sh -y --default-toolchain stable --profile minimal --component llvm-tools-preview && \
    rm /tmp/rustup-init.sh && \
    rm -rf /root/.rustup/toolchains/*/share/doc /root/.rustup/toolchains/*/share/man && \
    sysroot="$(/root/.cargo/bin/rustc --print sysroot)" && \
    host="$(/root/.cargo/bin/rustc -vV | sed -n 's/^host: //p')" && \
    cd "$sysroot/lib/rustlib/$host" && \
    for lib in lib/libLLVM*; do \
        if [ ! -L "$lib" ] && cmp -s "$lib" "$sysroot/lib/${lib#lib/}"; then \
            ln -sf "../../../${lib#lib/}" "$lib"; \
        fi; \
    done && \
    for f in "$sysroot/bin/cargo" "$sysroot/bin/rustc" \
             "$sysroot"/lib/librustc_driver-*.so "$sysroot"/lib/libLLVM.so.* \
             /root/.cargo/bin/rustup \
             bin/rust-lld bin/llvm-cov bin/llvm-profdata; do \
        if [ -f "$f" ]; then bin/llvm-strip --strip-all "$f"; fi; \
    done && \
    for f in $(sed -n "s|^file:lib/rustlib/$host/bin/||p" "$sysroot/lib/rustlib/manifest-llvm-tools-preview-$host"); do \
        case "$f" in llvm-cov|llvm-profdata) ;; *) rm "bin/$f" ;; esac; \
    done && \
    rm -f lib/librustc-stable_rt.*.a bin/wasm-component-ld
ENV PATH="/root/.cargo/bin:$PATH"
