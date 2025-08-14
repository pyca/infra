FROM alpine:latest
ARG VERSION
# One of x64 or arm64 or ppc64le
ARG ARCH
# The sha256sum for the node source tarball
ARG SHA256SUM

RUN mkdir -p /build
WORKDIR /build

RUN apk add --no-cache binutils-gold curl g++ gcc gnupg libgcc linux-headers make python3 libstdc++ patch
RUN mkdir -p /out/bin

RUN curl -O https://nodejs.org/dist/$VERSION/node-$VERSION.tar.gz
RUN echo "$SHA256SUM  node-$VERSION.tar.gz" | sha256sum -c -
RUN tar -zxvf node-$VERSION.tar.gz

# Apply https://github.com/abseil/abseil-cpp/pull/1918
# Needed to build on ppc64le
COPY frequency-musl-ppc64le.patch /tmp/
RUN if [ "$VERSION" = "v24.5.0" ]; then \
    cd node-$VERSION && \
    patch -p1 < /tmp/frequency-musl-ppc64le.patch; \
fi

RUN cd node-$VERSION && \
    case "$ARCH" in \
      ppc64le) CPU=ppc64 ;; \
      *) CPU="$ARCH" ;; \
    esac && \
    ./configure --dest-cpu=$CPU --fully-static && \
    make -j$(nproc)

RUN cp /build/node-$VERSION/LICENSE /out/LICENSE && cp /build/node-$VERSION/out/Release/node /out/bin/node

FROM scratch
COPY --from=0 /out/ /out
