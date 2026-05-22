ARG RELEASE
FROM debian:${RELEASE}

# Increment this to blow away the docker cache
ENV CACHE_BUSTER=5

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG=C.UTF-8

RUN apt-get -qq update && apt-get install -qq -y \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-venv \
    git \
    curl \
    pkg-config \
    zstd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir

RUN curl -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh && \
    sh /tmp/rustup-init.sh -y --default-toolchain stable --profile minimal --component llvm-tools-preview && \
    rm /tmp/rustup-init.sh
ENV PATH="/root/.cargo/bin:$PATH"
