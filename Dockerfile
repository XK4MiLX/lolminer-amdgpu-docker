FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV LOLMINER_VERSION=1.88

# Update the system and install necessary packages
RUN apt-get update && apt-get install -y \
    tar \
    curl \
    wget \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Download the AMDGPU package
RUN wget https://repo.radeon.com/amdgpu-install/23.40.2/ubuntu/jammy/amdgpu-install_6.0.60002-1_all.deb

# Install the AMDGPU package
RUN apt-get install -y ./amdgpu-install_6.0.60002-1_all.deb

# Install AMDGPU drivers with specified use cases
RUN amdgpu-install -y --accept-eula

# Add the default user to render and video groups
RUN usermod -a -G render,video $(whoami)


RUN wget https://github.com/Lolliedieb/lolMiner-releases/releases/download/${LOLMINER_VERSION}/lolMiner_v${LOLMINER_VERSION}_Lin64.tar.gz -O /tmp/lolMiner.tar.gz && \
    mkdir -p /opt/lolminer && \
    tar --strip-components=1 -xvf /tmp/lolMiner.tar.gz -C /opt/lolminer && \
    rm /tmp/lolMiner.tar.gz

# Make the lolMiner binary executable
RUN chmod +x /opt/lolminer/lolMiner

# Copy the entrypoint script into the image
COPY entrypoint.sh /opt/lolminer/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /opt/lolminer/entrypoint.sh

# Set working directory
WORKDIR /opt/lolminer

# Define environment variables with default values
ENV ALGO=""
ENV POOL=""
ENV WALLET=""
ENV EXTRA=""

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/opt/lolminer/entrypoint.sh"]
