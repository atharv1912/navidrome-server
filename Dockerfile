FROM deluan/navidrome:latest

USER root

RUN apk update && apk add --no-cache \
    curl \
    fuse3 \
    ca-certificates \
    bash \
    unzip \
    gettext \
    && curl https://rclone.org/install.sh | bash

RUN mkdir -p /music /data

COPY start.sh /start.sh
RUN chmod +x /start.sh && \
    echo "=== Checking start.sh ===" && \
    head -1 /start.sh && \
    ls -la /start.sh

EXPOSE 4533

ENTRYPOINT []
CMD ["/start.sh"]