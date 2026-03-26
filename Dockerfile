FROM deluan/navidrome:latest

USER root

RUN apt-get update && apt-get install -y \
    curl \
    fuse3 \
    ca-certificates \
    && curl https://rclone.org/install.sh | bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /music /data

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 4533
CMD ["/start.sh"]
