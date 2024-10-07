ARG NODE_ARCH_RELEASE
FROM ghcr.io/pyca/static-nodejs-${NODE_ARCH_RELEASE} as staticnodejs

FROM alpine:latest

# Increment this to blow away the Docker cache when needed
ENV CACHE_BUSTER 1

# Set environment variables
ENV LANG C.UTF-8
ENV PATH="/root/.cargo/bin:$PATH"

# Combine package installations and clean up in one layer
RUN apk add --no-cache git libffi-dev curl python3-dev openssl-dev bash gcc musl-dev tar pkgconfig zstd \
    libucontext-dev musl-obstack-dev make && \
    python3 -m venv /venv && \
    /venv/bin/pip install -U pip wheel --no-cache-dir && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal --component llvm-tools-preview

# Copy the Node.js static binary from the staticnodejs stage
COPY --from=staticnodejs /out/ /staticnode/

# Download, build, and install gcompat in one RUN layer
RUN if [ $(uname -m) = "x86_64" ]; then \
        _ld="ld-linux-x86-64.so.2"; \
        _arch="x86_64"; \
    else \
        _ld="ld-linux-aarch64.so.1"; \
        _arch="aarch64"; \
    fi; \
    curl -O https://git.adelielinux.org/adelie/gcompat/-/archive/8e300a60/gcompat-ae300a60.tar.gz && \
    tar xf gcompat*.tar.gz && \
    cd gcompat* && \
    make WITH_LIBUCONTEXT=1 WITH_OBSTACK=musl-obstack LINKER_PATH="/lib/ld-musl-${_arch}.so.1" LOADER_NAME="${_ld}" install && \
    mkdir /lib64 && \
    ln -s "/lib/${_ld}" "/lib64/${_ld}" && \
    ln -s "/lib/${_ld}" /lib/libresolv.so.2 && \
    cd .. && rm -rf gcompat* && \
    apk del gcc musl-dev make  # Clean up build dependencies
