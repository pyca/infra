ARG RELEASE
FROM ${RELEASE}
ARG FIPS
ARG RELEASE

RUN yum install -y gcc libffi-devel python3-devel openssl-devel git which pkg-config zstd && yum clean all
RUN if [ "$RELEASE" = "redhat/ubi8" ] ; then yum install -y python38-devel; fi

RUN if [ "$FIPS" = "1" ] ; then if [ "$RELEASE" = "redhat/ubi8" ] ; then rm -rf /etc/system-fips && touch /etc/system-fips; else update-crypto-policies --set FIPS; fi && echo "FIPS mode"; else echo "Not FIPS mode"; fi

RUN if [ "$RELEASE" = "redhat/ubi8" ] ; then python3.8 -m venv /venv; else python3 -m venv /venv; fi; /venv/bin/pip install -U pip wheel --no-cache-dir

RUN curl -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh && \
    sh /tmp/rustup-init.sh -y --default-toolchain stable --profile minimal --component llvm-tools-preview && \
    rm /tmp/rustup-init.sh
ENV PATH="/root/.cargo/bin:$PATH"
