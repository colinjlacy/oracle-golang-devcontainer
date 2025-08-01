# Use Oracle Linux 9 with Instant Client as base image
FROM ghcr.io/oracle/oraclelinux9-instantclient:23

# Set environment variables for Go
ENV GO_VERSION=1.24.5
ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH
ENV CGO_ENABLED=1

# Install system dependencies
RUN dnf update -y && \
    dnf install -y \
        bash \
        coreutils \
        util-linux \
        shadow-utils \
        findutils \
        which \
        procps-ng \
        gcc \
        gcc-c++ \
        make \
        git \
        curl \
        tar \
        gzip \
        ca-certificates \
        libaio \
        pkg-config \
        openssh-clients && \
    dnf clean all

# Install Go
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

# Create Go workspace
RUN mkdir -p $GOPATH/src $GOPATH/bin && chmod -R 777 $GOPATH

# Set up shell environment
RUN echo 'export PATH=$PATH:/usr/local/go/bin:/go/bin' >> /etc/profile && \
    echo 'export GOROOT=/usr/local/go' >> /etc/profile && \
    echo 'export GOPATH=/go' >> /etc/profile && \
    echo 'export CGO_ENABLED=1' >> /etc/profile

# Configure git (required for DevPod Agent)
RUN git config --system --add safe.directory '*' && \
    git config --system credential.helper ''

# Verify installations
RUN go version && git --version && bash --version

# Set default shell to bash
ENV SHELL=/bin/bash
