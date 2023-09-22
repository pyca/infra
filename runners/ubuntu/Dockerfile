ARG RELEASE
FROM ubuntu:${RELEASE}

# Increment this to blow away the docker cache
ENV CACHE_BUSTER 3

ENV DEBIAN_FRONTEND noninteractive

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG C.UTF-8

RUN apt-get -qq update && apt-get install -qq -y \
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

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir

# Work around https://github.com/rust-lang/rustup/issues/3122
ENV RUSTUP_USE_CURL 1
RUN cat /proc/cpuinfo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal --component llvm-tools-preview -v
ENV PATH="/root/.cargo/bin:$PATH"
