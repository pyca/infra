FROM alpine:latest

# Increment this to blow away the docker cache
ENV CACHE_BUSTER 1

# This is needed because otherwise `sys.getfilesystemencoding()` returns
# "ANSI_X3.4-1968".
ENV LANG C.UTF-8

RUN apk add --no-cache git libffi-dev curl \
    python3-dev openssl-dev bash gcc musl-dev tar pkgconfig zstd libucontext-dev musl-obstack-dev make

# Derived from https://git.alpinelinux.org/aports/tree/community/gcompat/APKBUILD?h=3.18-stable and pinned to the
# latest gcompat at the time this was written
RUN if [ $(uname -m) = "x86_64" ]; \
    then \
        _ld="ld-linux-x86-64.so.2"; \
        _arch="x86_64"; \
    else \
        _ld="ld-linux-aarch64.so.1"; \
        _arch="aarch64"; \
    fi; \
    curl -O https://git.adelielinux.org/adelie/gcompat/-/archive/8e300a60/gcompat-ae300a60.tar.gz && \
    tar xf gcompat*.tar.gz && \
    cd gcompat* && \
    make WITH_LIBUCONTEXT=1 WITH_OBSTACK=musl-obstack LINKER_PATH="/lib/ld-musl-${_arch}.so.1" LOADER_NAME="${_ld}" install && \
    mkdir /lib64 &&\
    ln -s "/lib/${_ld}" "/lib64/${_ld}" &&\
    ln -s "/lib/${_ld}" /lib/libresolv.so.2 && \
    cd .. && rm -rf gcompat*

RUN python3 -m venv /venv && /venv/bin/pip install -U pip wheel --no-cache-dir

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal --component llvm-tools-preview
ENV PATH="/root/.cargo/bin:$PATH"
