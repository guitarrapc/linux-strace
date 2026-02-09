FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    binutils \
    build-essential \
    curl \
    wget \
    ca-certificates \
    gnupg \
    sysstat \
    fonts-takao \
    fio \
    jq \
    strace \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Go
RUN wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz && \
    rm go1.24.1.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
RUN go install -buildmode=shared std

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH=$PATH:/root/.cargo/bin

# C#
RUN curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh
RUN bash ./dotnet-install.sh --version 10.0.102
ENV DOTNET_ROOT=/root/.dotnet \
    PATH=$PATH:/root/.dotnet

WORKDIR /workspace
