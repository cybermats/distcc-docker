FROM ubuntu:20.04

LABEL maintainer="Mats Fredriksson <cybermats@gmail.com>"

LABEL description="A distccd image based on ubuntu 20.04"
ENV LANG=en_US.utf8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    automake \
    build-essential \
    curl \
    clang \
    distcc \
    doxygen \
    gcc \
    git \
    graphviz \
    htop \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/home/distcc
RUN useradd -s /bin/bash distcc

ENTRYPOINT [\
    "distccd", \
    "--daemon", \
    "--no-detach", \
    "--user", "distcc", \
    "--port", "3632", \
    "--stats", \
    "--stats-port", "3633", \
    "--log-stderr", \
    "--listen", "0.0.0.0" \
]

CMD [\
    "--allow", "0.0.0.0/0", \
    "--nice", "5", \
    "--jobs", "5" \
]

EXPOSE \
    3632/tcp \
    3633/tcp

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://0.0.0.0:3633/ || exit 1
