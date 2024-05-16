FROM alpine:latest
ARG VERSION
# One of x64 or arm64
ARG ARCH

RUN mkdir -p /build
WORKDIR /build

RUN apk add --no-cache binutils-gold curl g++ gcc gnupg libgcc linux-headers make python3 libstdc++
RUN mkdir -p /out/bin

RUN curl -O https://nodejs.org/dist/$VERSION/node-$VERSION.tar.gz
RUN tar -zxvf node-$VERSION.tar.gz
RUN cd node-$VERSION && ./configure --dest-cpu=$ARCH --fully-static && make -j$(nproc)
RUN cp /build/node-$VERSION/LICENSE /out/LICENSE && cp /build/node-$VERSION/out/Release/node /out/bin/node

FROM scratch
COPY --from=0 /out/ /out
