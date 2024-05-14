FROM alpine:latest
ARG VERSION
# One of x64 or arm64
ARG ARCH

RUN mkdir -p /build
WORKDIR /build

RUN apk add --no-cache binutils-gold curl g++ gcc gnupg libgcc linux-headers make python3 libstdc++
RUN mkdir -p /out/bin
RUN mkdir -p /node_staging

RUN curl -O https://nodejs.org/dist/$VERSION/node-$VERSION.tar.gz && tar -zxvf node-$VERSION.tar.gz && cd node-$VERSION && ./configure --dest-cpu=$ARCH --fully-static && make -j4 && cp /build/node-$VERSION/LICENSE /out/LICENSE && cp /build/node-$VERSION/out/Release/node /out/bin/node && rm -rf /build
WORKDIR /out
RUN tar -czvf /node_staging/node-$VERSION-static-$ARCH.tar.gz ./bin ./LICENSE
