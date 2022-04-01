ARG RELEASE
FROM debian:${RELEASE}

# Increment this to blow away the docker cache
ENV CACHE_BUSTER 5

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
    pkg-config

RUN apt-get -qq update; if grep -q "sid" /etc/os-release; then apt-get install -qq -y python3-distutils; fi

RUN python3 -m venv /venv && /venv/bin/pip install tox coverage

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:$PATH"
