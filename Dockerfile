FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Core system tools
RUN apt-get update && apt-get install -y \
    curl wget git vim nano htop \
    build-essential ca-certificates gnupg \
    python3 python3-pip python3-venv \
    unzip zip tini ttyd \
    && rm -rf /var/lib/apt/lists/*

# Node.js (via NodeSource — LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Global Node packages
RUN npm install -g yarn pnpm typescript ts-node nodemon

# Python packages
RUN pip3 install --upgrade pip \
    && pip3 install requests flask fastapi uvicorn django \
                   numpy pandas jupyter

# Create a non-root user
RUN useradd -m -s /bin/bash devuser
USER devuser
WORKDIR /home/devuser

# Persistent data volume
VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["ttyd", "--port", "8080", \
     "--credential", "${USERNAME}:${PASSWORD}", \
     "bash"]
