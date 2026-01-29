ARG RELEASE
FROM ubuntu:${RELEASE}

# Increment this to blow away the docker cache
ENV CACHE_BUSTER=3

ENV DEBIAN_FRONTEND=noninteractive

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-venv \
    git \
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
        apt-get install -y libc6:arm64 libstdc++6:arm64; \
    fi

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal --component llvm-tools-preview
ENV PATH="/root/.cargo/bin:$PATH"
