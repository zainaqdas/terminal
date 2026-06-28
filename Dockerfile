FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Core system tools
RUN apt-get update && apt-get install -y \
    curl wget git vim nano htop \
    build-essential ca-certificates gnupg \
    python3 python3-pip python3-venv \
    unzip zip tini \
    && rm -rf /var/lib/apt/lists/*

# Install latest ttyd binary (v1.7.7) instead of outdated apt version
RUN curl -L https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    -o /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

# Node.js (LTS via NodeSource)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Global Node packages
RUN npm install -g yarn pnpm typescript ts-node nodemon

# Python packages
RUN pip3 install --upgrade pip \
    && pip3 install requests flask fastapi uvicorn django \
                   numpy pandas jupyter

WORKDIR /root

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/bin/bash", "-c", "ttyd --port 8080 --credential ${USERNAME}:${PASSWORD} --font-size 18 --font-family 'Fira Code,Cascadia Code,Consolas,Courier New,monospace' bash"]
