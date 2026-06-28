FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=8080

# -----------------------------------------------------
# Install system packages
# -----------------------------------------------------

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    bash \
    nano \
    vim \
    tmux \
    htop \
    unzip \
    zip \
    tree \
    jq \
    sudo \
    ca-certificates \
    gnupg \
    software-properties-common \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    openssh-client \
    xz-utils \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------
# Install Node.js 22
# -----------------------------------------------------

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# -----------------------------------------------------
# Install code-server
# -----------------------------------------------------

RUN curl -fsSL https://code-server.dev/install.sh | sh

# -----------------------------------------------------
# Install global npm packages
# (Must be done as root)
# -----------------------------------------------------

RUN npm install -g \
    pnpm \
    yarn \
    typescript \
    tsx \
    nodemon

# -----------------------------------------------------
# Create developer user
# -----------------------------------------------------

RUN useradd -m -s /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER developer

WORKDIR /home/developer

# -----------------------------------------------------
# Python packages
# -----------------------------------------------------

RUN pip3 install --user \
    virtualenv \
    ipython \
    requests \
    flask \
    fastapi \
    uvicorn

# -----------------------------------------------------
# Configure code-server
# -----------------------------------------------------

RUN mkdir -p ~/.config/code-server

RUN printf "bind-addr: 0.0.0.0:8080\nauth: none\ncert: false\n" > ~/.config/code-server/config.yaml

RUN mkdir -p /home/developer/workspace

WORKDIR /home/developer/workspace

EXPOSE 8080

CMD ["code-server"]
