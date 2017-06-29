ARG ARCH=x86_64
FROM quay.io/pypa/manylinux1_${ARCH}
MAINTAINER Python Cryptographic Authority
ADD install_openssl.sh /root/install_openssl.sh
WORKDIR /root
ADD https://www.cpan.org/src/5.0/perl-5.24.1.tar.gz .
RUN tar zxf perl-5.24.1.tar.gz && \
    cd perl-5.24.1 && \
    ./Configure -des -Dprefix=/opt/perl && \
    make -j4 && make install
RUN sh install_openssl.sh ${ARCH}
