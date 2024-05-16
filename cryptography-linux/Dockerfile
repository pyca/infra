ARG NODE_ARCH_RELEASE
ARG PYCA_RELEASE
FROM ghcr.io/pyca/static-nodejs-${NODE_ARCH_RELEASE} as staticnodejs
FROM quay.io/pypa/${PYCA_RELEASE}
LABEL org.opencontainers.image.authors="Python Cryptographic Authority"
WORKDIR /root
RUN \
  if [ $(uname -m) = "x86_64" ]; \
  then \
    if stat /etc/redhat-release 1>&2 2>/dev/null; then \
      yum -y install binutils perl-IPC-Cmd && \
      yum -y clean all && \
      rm -rf /var/cache/yum; \
    elif stat /etc/debian_version 1>&2 2>/dev/null; then \
      export DEBIAN_FRONTEND=noninteractive && \
      apt-get update -qq && \
      apt-get install -qq -y --no-install-recommends prelink && \
      apt-get clean -qq && \
      rm -rf /var/lib/apt/lists/*; \
    fi; \
  fi

# This is done as two separate steps because readelf (binutils) is not available on
# aarch64, and libffi-dev/devel isn't required on x86_64 (since wheels exist)
RUN \
  if [ $(uname -m) = "aarch64" ]; \
  then \
    if stat /etc/redhat-release 1>&2 2>/dev/null; then \
      yum -y install libffi-devel perl-IPC-Cmd && \
      yum -y clean all && \
      rm -rf /var/cache/yum; \
    elif stat /etc/debian_version 1>&2 2>/dev/null; then \
      export DEBIAN_FRONTEND=noninteractive && \
      apt-get update -qq && \
      apt-get install -qq -y --no-install-recommends libffi-dev && \
      apt-get clean -qq && \
      rm -rf /var/lib/apt/lists/*; \
    fi; \
  fi

COPY --from=staticnodejs /out/ /staticnode/
ADD install_openssl.sh /root/install_openssl.sh
ADD openssl-version.sh /root/openssl-version.sh
RUN ./install_openssl.sh

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:$PATH"
