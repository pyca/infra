FROM registry.fedoraproject.org/fedora:latest

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG C.UTF-8

RUN dnf install -y gcc redhat-rpm-config libffi-devel python3 \
    python3-devel openssl-devel git findutils which pkg-config zstd && \
    dnf clean all

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:$PATH"
