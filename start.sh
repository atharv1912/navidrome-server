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

# Run rclone mount in background
rclone mount r2:music /music \
  --read-only \
  --allow-other \
  --dir-cache-time 60m \
  --vfs-cache-mode full \
  --vfs-cache-max-size 150M \
  --vfs-cache-max-age 10m \
  --vfs-read-chunk-size 5M \
  --vfs-read-chunk-size-limit 50M \
  --log-level INFO &

echo ">>> Waiting for mount to be ready..."
sleep 5

# Verify mount
if mountpoint -q /music; then
    echo "? R2 bucket mounted successfully to /music"
else
    echo "??  Warning: R2 bucket may not be mounted correctly"
fi

echo ">>> Starting Navidrome..."

# Set Navidrome environment variables
export ND_DATAFOLDER="/data"
export ND_MUSICFOLDER="/music"

# Start Navidrome
exec /app/navidrome