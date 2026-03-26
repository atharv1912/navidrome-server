#!/bin/bash
set -e

echo ">>> Configuring rclone for Cloudflare R2..."

mkdir -p /root/.config/rclone

cat > /root/.config/rclone/rclone.conf <<EOF
[r2]
type = s3
provider = Cloudflare
access_key_id = ${R2_ACCESS_KEY_ID}
secret_access_key = ${R2_SECRET_ACCESS_KEY}
endpoint = ${R2_ENDPOINT}
acl = private
EOF

echo ">>> Mounting R2 bucket to /music..."

mkdir -p /music

rclone mount r2:music /music \
  --read-only \
  --allow-other \
  --dir-cache-time 60m \
  --vfs-cache-mode full \
  --vfs-cache-max-size 150M \
  --vfs-cache-max-age 10m \
  --vfs-read-chunk-size 5M \
  --vfs-read-chunk-size-limit 50M \
  --log-level INFO \
  --daemon

echo ">>> Waiting for mount to be ready..."
sleep 5

echo ">>> Starting Navidrome..."
exec /navidrome

