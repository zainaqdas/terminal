FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=8080

# Install system packages
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    wget \
    git \
    nano \
    vim \
    tmux \
    htop \
    unzip \
    zip \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    software-properties-common \
    ca-certificates \
    openssh-client \
    sudo \
    xz-utils

# Install Node.js 22
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# Install ttyd
RUN wget https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    -O /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd

# Create developer user
RUN useradd -ms /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER developer
WORKDIR /home/developer

# Useful Python packages
RUN pip3 install --break-system-packages \
    requests \
    flask \
    fastapi \
    uvicorn \
    ipython \
    virtualenv

# Useful Node packages
RUN npm install -g \
    npm \
    yarn \
    pnpm \
    typescript \
    tsx \
    nodemon

EXPOSE 8080

CMD ttyd \
    --writable \
    --port ${PORT} \
    bash
