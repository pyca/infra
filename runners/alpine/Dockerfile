ARG NODE_ARCH_RELEASE
FROM ghcr.io/pyca/static-nodejs-${NODE_ARCH_RELEASE} AS staticnodejs

FROM alpine:latest

# Increment this to blow away the docker cache
ENV CACHE_BUSTER=1

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG=C.UTF-8

RUN apk add --no-cache git libffi-dev curl \
    python3-dev openssl-dev bash gcc musl-dev tar pkgconfig zstd make

COPY --from=staticnodejs /out/ /staticnode/

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal --component llvm-tools-preview
ENV PATH="/root/.cargo/bin:$PATH"
