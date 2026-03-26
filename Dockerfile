FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    curl \
    fuse3 \
    ca-certificates \
    unzip \
    && curl https://rclone.org/install.sh | bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app /music /data

RUN ARCH=$(dpkg --print-architecture) && \
    curl -L "https://github.com/navidrome/navidrome/releases/latest/download/navidrome_linux_${ARCH}.tar.gz" \
    | tar -xz -C /app && \
    chmod +x /app/navidrome

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 4533
CMD ["/start.sh"]
