ARG NODE20_ARCH_RELEASE
ARG NODE24_ARCH_RELEASE
FROM ghcr.io/pyca/static-nodejs-${NODE20_ARCH_RELEASE} AS staticnodejs20
FROM ghcr.io/pyca/static-nodejs-${NODE24_ARCH_RELEASE} AS staticnodejs24

FROM alpine:latest

# Increment this to blow away the docker cache
ENV CACHE_BUSTER=1

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG=C.UTF-8

RUN apk add --no-cache git libffi-dev curl \
    python3-dev openssl-dev bash gcc musl-dev tar pkgconfig zstd make rustup

COPY --from=staticnodejs20 /out/ /staticnode/20/
COPY --from=staticnodejs24 /out/ /staticnode/24/

RUN rustup-init -y --default-toolchain stable --profile minimal --component llvm-tools-preview
ENV PATH="/root/.cargo/bin:$PATH"

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir
