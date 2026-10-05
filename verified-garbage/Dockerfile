# The 32-bit Linux userspaces verified-garbage's CI runs its x86 (i386) and
# ARMv7 (armhf) jobs in, natively on a 64-bit runner: build it for
# linux/386 on an x86-64 runner and for linux/arm/v7 on an ARM64 one.
FROM debian:trixie-slim

# Increment this to blow away the docker cache
ENV CACHE_BUSTER=1

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG=C.UTF-8

# Docker overlay filesystems can reject directory renames during toolchain
# updates with EXDEV. Allow rustup to copy the files in that case.
ENV RUSTUP_PERMIT_COPY_RENAME=1

# Don't unpack things nothing in CI uses: static OpenSSL, gcc's LTO backend,
# and the sanitizer runtimes (hard deps of libgcc-dev).
RUN printf '%s\n' \
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

# Only what the jobs use:
# * the runner's (64-bit) libc and libstdc++, so that the Node binary GitHub
#   Actions injects into the container for JS actions can run;
# * gcc and libc6-dev, rustc's linker (with binutils' readelf);
# * git and ca-certificates, for actions/checkout;
# * python3, for the coverage export and the benchmark comparison;
# * zstd, for actions/cache (through Swatinem/rust-cache);
# * libssl-dev, pkg-config and openssl, for the benchmarks, which link
#   OpenSSL (rust-openssl) and record its version.
RUN case "$(dpkg --print-architecture)" in \
        i386) runner_arch=amd64 ;; \
        armhf) runner_arch=arm64 ;; \
        *) echo "unsupported architecture: $(dpkg --print-architecture)" >&2; exit 1 ;; \
    esac && \
    dpkg --add-architecture "$runner_arch" && \
    apt-get -qq update && apt-get install -qq -y --no-install-recommends \
        "libc6:$runner_arch" \
        "libstdc++6:$runner_arch" \
        gcc \
        libc6-dev \
        git \
        ca-certificates \
        python3 \
        libssl-dev \
        pkg-config \
        openssl \
        zstd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

# A complete, unstripped toolchain in a fixed home (the jobs' HOME is
# /github/home), so that the jobs' `rustup toolchain install` can update it
# in place. The host is the userspace's, not the kernel's, and the stable
# toolchain has every component and target the jobs install, so that they
# download nothing until stable changes. Deduplicate libLLVM and strip the
# big binaries (with llvm-strip; GNU strip breaks them), as the other runner
# images do. Keep all files recorded in rustup's component manifests:
# deleting even unused files prevents rustup from uninstalling or updating
# the toolchain.
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN case "$(dpkg --print-architecture)" in \
        i386) host=i686-unknown-linux-gnu; targets= ;; \
        armhf) host=armv7-unknown-linux-gnueabihf; targets=thumbv7neon-unknown-linux-gnueabihf ;; \
    esac && \
    url="https://static.rust-lang.org/rustup/dist/$host/rustup-init" && \
    python3 -c 'import sys, urllib.request; urllib.request.urlretrieve(sys.argv[1], sys.argv[2])' "$url" /tmp/rustup-init && \
    python3 -c 'import sys, urllib.request; sys.stdout.write(urllib.request.urlopen(sys.argv[1]).read().decode().split()[0] + "  /tmp/rustup-init\n")' "$url.sha256" | sha256sum -c - && \
    chmod +x /tmp/rustup-init && \
    /tmp/rustup-init -y --no-modify-path --profile minimal --default-host "$host" \
        --default-toolchain stable --component clippy,rustfmt,llvm-tools \
        ${targets:+--target "$targets"} && \
    rm /tmp/rustup-init && \
    sysroot="$(rustc --print sysroot)" && \
    cd "$sysroot/lib/rustlib/$host" && \
    for lib in lib/libLLVM*; do \
        if [ ! -L "$lib" ] && cmp -s "$lib" "$sysroot/lib/${lib#lib/}"; then \
            ln -sf "../../../${lib#lib/}" "$lib"; \
        fi; \
    done && \
    for f in "$sysroot/bin/cargo" "$sysroot/bin/rustc" \
             "$sysroot/bin/clippy-driver" "$sysroot/bin/cargo-clippy" \
             "$sysroot/bin/rustfmt" "$sysroot/bin/cargo-fmt" \
             "$sysroot"/lib/librustc_driver-*.so "$sysroot"/lib/libLLVM.so.* \
             "$CARGO_HOME/bin/rustup" \
             bin/rust-lld bin/llvm-cov bin/llvm-profdata; do \
        if [ -f "$f" ]; then bin/llvm-strip --strip-all "$f"; fi; \
    done && \
    rustc -vV && cargo -V
