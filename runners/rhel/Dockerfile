ARG RELEASE
FROM ${RELEASE}
ARG FIPS
ARG RELEASE

# git-core rather than git (which adds perl and git-core-doc), no weak deps,
# no docs, and drop gcc's LTO backend since nothing builds with -flto.
RUN yum install -y --setopt=install_weak_deps=False --setopt=tsflags=nodocs \
    gcc libffi-devel python3-devel openssl-devel git-core which pkg-config zstd && \
    yum clean all && \
    rm -f /usr/libexec/gcc/*/*/lto1 /usr/bin/lto-dump
RUN if [ "$RELEASE" = "redhat/ubi8" ] ; then yum install -y python38-devel; fi

RUN if [ "$FIPS" = "1" ] ; then if [ "$RELEASE" = "redhat/ubi8" ] ; then rm -rf /etc/system-fips && touch /etc/system-fips; else update-crypto-policies --set FIPS; fi && echo "FIPS mode"; else echo "Not FIPS mode"; fi

RUN if [ "$RELEASE" = "redhat/ubi8" ] ; then python3.8 -m venv /venv; else python3 -m venv /venv; fi; /venv/bin/pip install -U pip wheel --no-cache-dir

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
        if [ ! -L "$lib" ] && [ "$(sha256sum < "$lib")" = "$(sha256sum < "$sysroot/lib/${lib#lib/}")" ]; then \
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
