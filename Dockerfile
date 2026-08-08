FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update apt, install system deps, upgrade pip, and install LiteLLM/FastAPI in ONE single layer to prevent blob bloat
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    bash \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/* \
    && python3 -m pip install --upgrade pip \
    && pip3 install --no-cache-dir "litellm[proxy]" "fastapi<0.140.0"

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Create directories for Home Assistant
RUN mkdir -p /config

# Set working directory
WORKDIR /config

# Expose port
EXPOSE 4000

# Run script
CMD ["/run.sh"]