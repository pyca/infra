FROM alpine:latest
ARG VERSION
# One of x64 or arm64 or ppc64le
ARG ARCH
# The sha256sum for the node source tarball
ARG SHA256SUM

RUN mkdir -p /build
WORKDIR /build

RUN apk add --no-cache binutils-gold curl g++ gcc gnupg libgcc linux-headers make python3 libstdc++
RUN mkdir -p /out/bin

RUN curl -O https://nodejs.org/dist/$VERSION/node-$VERSION.tar.gz
RUN echo "$SHA256SUM  node-$VERSION.tar.gz" | sha256sum -c -
RUN tar -zxvf node-$VERSION.tar.gz

RUN cd node-$VERSION && \
    case "$ARCH" in \
      ppc64le) CPU=ppc64 ;; \
      *) CPU="$ARCH" ;; \
    esac && \
    ./configure --dest-cpu=$CPU --fully-static && \
    make -j$(nproc)

FROM scratch
COPY --from=0 /out/ /out
