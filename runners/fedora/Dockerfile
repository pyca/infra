FROM registry.fedoraproject.org/fedora:latest

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG=C.UTF-8

# git-core rather than git (which adds perl and git-core-doc), no weak deps,
# and drop gcc's LTO backend since nothing builds with -flto.
RUN dnf install -y --setopt=install_weak_deps=False gcc redhat-rpm-config libffi-devel python3 \
    python3-devel python-unversioned-command openssl-devel git-core findutils which pkg-config zstd rustup && \
    dnf clean all && \
    rm -f /usr/libexec/gcc/*/*/lto1 /usr/bin/lto-dump

# rustup-init copies itself to ~/.cargo/bin/rustup; symlink it instead. We only
# need llvm-profdata and llvm-cov from llvm-tools-preview (for rust coverage).
# Its libLLVM.so is identical to rustc's, so symlink it, then strip the big
# binaries (with llvm-strip; GNU strip breaks them) and drop the rest.
RUN rustup-init -y --default-toolchain stable --profile minimal --component llvm-tools-preview && \
    ln -sf /usr/bin/rustup-init /root/.cargo/bin/rustup && \
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
             bin/rust-lld bin/llvm-cov bin/llvm-profdata; do \
        if [ -f "$f" ]; then bin/llvm-strip --strip-all "$f"; fi; \
    done && \
    for f in $(sed -n "s|^file:lib/rustlib/$host/bin/||p" "$sysroot/lib/rustlib/manifest-llvm-tools-preview-$host"); do \
        case "$f" in llvm-cov|llvm-profdata) ;; *) rm "bin/$f" ;; esac; \
    done && \
    rm -f lib/librustc-stable_rt.*.a bin/wasm-component-ld
ENV PATH="/root/.cargo/bin:$PATH"

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir
