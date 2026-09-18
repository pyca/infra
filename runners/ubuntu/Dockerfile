ARG RELEASE
FROM ubuntu:${RELEASE}

# Increment this to blow away the docker cache
ENV CACHE_BUSTER=3

ENV DEBIAN_FRONTEND=noninteractive

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG=C.UTF-8

# python3-dev ships a static libpython that nothing we build links against
# (extension modules link dynamically, if at all), so don't unpack it.
RUN echo 'path-exclude=/usr/lib/python3*/config-*/libpython*.a' > /etc/dpkg/dpkg.cfg.d/excludes-libpython-static

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

RUN curl -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh && \
    sh /tmp/rustup-init.sh -y --default-toolchain stable --profile minimal --component llvm-tools-preview && \
    rm /tmp/rustup-init.sh && \
    rm -rf /root/.rustup/toolchains/*/share/doc /root/.rustup/toolchains/*/share/man
ENV PATH="/root/.cargo/bin:$PATH"
