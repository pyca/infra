ARG PYCA_RELEASE
FROM quay.io/pypa/${PYCA_RELEASE}
ARG PYCA_RELEASE
MAINTAINER Python Cryptographic Authority
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
    else \
      # gcompat's latest release (as of 2024-02-04) doesn't support features we need for GH's node20 \
      # so instead we build the entire thing ourselves from source. \
      # Derived from https://git.alpinelinux.org/aports/tree/community/gcompat/APKBUILD?h=3.18-stable  \
      # and pinned to the latest gcompat at the time this was written \
      apk add --no-cache make libucontext-dev musl-obstack-dev; \
      _ld="ld-linux-x86_64.so.2"; \
      _arch="aarch64"; \
      curl -O https://git.adelielinux.org/adelie/gcompat/-/archive/8e300a60/gcompat-ae300a60.tar.gz && \
      tar xf gcompat*.tar.gz && \
      cd gcompat* && \
      make WITH_LIBUCONTEXT=1 WITH_OBSTACK=musl-obstack LINKER_PATH="/lib/ld-musl-${_arch}.so.1" LOADER_NAME="${_ld}" install && \
      mkdir /lib64 &&\
      ln -s "/lib/${_ld}" "/lib64/${_ld}" &&\
      ln -s "/lib/${_ld}" /lib/libresolv.so.2 && \
      cd .. && rm -rf gcompat*; \
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
    else \
      # gcompat's latest release (as of 2024-02-04) doesn't support features we need for GH's node20 \
      # so instead we build the entire thing ourselves from source. \
      # Derived from https://git.alpinelinux.org/aports/tree/community/gcompat/APKBUILD?h=3.18-stable  \
      # and pinned to the latest gcompat at the time this was written \
      apk add --no-cache make libucontext-dev musl-obstack-dev; \
      _ld="ld-linux-aarch64.so.1"; \
      _arch="aarch64"; \
      curl -O https://git.adelielinux.org/adelie/gcompat/-/archive/8e300a60/gcompat-ae300a60.tar.gz && \
      tar xf gcompat*.tar.gz && \
      cd gcompat* && \
      make WITH_LIBUCONTEXT=1 WITH_OBSTACK=musl-obstack LINKER_PATH="/lib/ld-musl-${_arch}.so.1" LOADER_NAME="${_ld}" install && \
      mkdir /lib64 &&\
      ln -s "/lib/${_ld}" "/lib64/${_ld}" &&\
      ln -s "/lib/${_ld}" /lib/libresolv.so.2 && \
      cd .. && rm -rf gcompat*; \
    fi; \
  fi

ADD install_openssl.sh /root/install_openssl.sh
ADD openssl-version.sh /root/openssl-version.sh
RUN ./install_openssl.sh

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:$PATH"
