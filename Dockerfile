FROM ubuntu:24.04 AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG XFO_CORE_REPO=https://github.com/0xForce-Network/xfo-core.git
ARG XFO_CORE_BRANCH=main
ARG GITHUB_TOKEN

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    cmake \
    pkg-config \
    ca-certificates \
    libboost-all-dev \
    libunbound-dev \
    libunwind-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libreadline-dev \
    libzmq3-dev \
    libsodium-dev \
    libhidapi-dev \
    libhidapi-libusb0 \
    libminiupnpc-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN if [ -n "${GITHUB_TOKEN}" ]; then \
      git clone --depth 1 --branch ${XFO_CORE_BRANCH} https://x-access-token:${GITHUB_TOKEN}@github.com/0xForce-Network/xfo-core.git /opt/xfo-core; \
    else \
      git clone --depth 1 --branch ${XFO_CORE_BRANCH} ${XFO_CORE_REPO} /opt/xfo-core; \
    fi

WORKDIR /opt/xfo-core
RUN make release -j"$(nproc)"

COPY . /opt/xfo-explorer
WORKDIR /opt/xfo-explorer
RUN cmake -S . -B build -DMONERO_DIR=/opt/xfo-core
RUN cmake --build build -j"$(nproc)"

FROM ubuntu:24.04 AS final

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libboost-filesystem1.83.0 \
    libboost-chrono1.83.0 \
    libboost-program-options1.83.0 \
    libboost-regex1.83.0 \
    libboost-serialization1.83.0 \
    libboost-system1.83.0 \
    libboost-thread1.83.0 \
    libcurl4 \
    libssl3 \
    libsodium23 \
    libunbound8 \
    libzmq5 \
    libhidapi-libusb0 \
    libminiupnpc18 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash monero
USER monero
WORKDIR /home/monero

COPY --from=builder --chown=monero:monero /opt/xfo-explorer/build/xmrblocks ./xmrblocks
COPY --from=builder --chown=monero:monero /opt/xfo-explorer/build/templates ./templates

VOLUME /home/monero/.bitmonero
EXPOSE 8081

CMD ["./xmrblocks", "--daemon-url=ai_devnode:18081", "--enable-json-api", "--enable-autorefresh-option", "--enable-emission-monitor", "--enable-pusher"]
