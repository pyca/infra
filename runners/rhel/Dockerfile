ARG RELEASE
FROM ${RELEASE}
ARG FIPS
ARG RELEASE

RUN yum install -y gcc libffi-devel python3-devel openssl-devel git which pkg-config zstd
RUN if [ "$RELEASE" = "redhat/ubi8" ] ; then yum install -y python38-devel; fi

RUN if [ "$FIPS" = "1" ] ; then rm -rf /etc/system-fips && touch /etc/system-fips && echo "FIPS mode"; else echo "Not FIPS mode"; fi

RUN if [ "$RELEASE" = "redhat/ubi8" ] ; then python3.8 -m venv /venv; else python3 -m venv /venv; fi

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable --profile minimal
ENV PATH="/root/.cargo/bin:$PATH"
