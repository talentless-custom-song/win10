#!/bin/bash
# Bat lai Windows sau khi Codespace ngu
cd "$(dirname "$0")"
docker start windows 2>/dev/null || docker compose up -d
if command -v tailscaled >/dev/null 2>&1 && ! pgrep tailscaled >/dev/null 2>&1; then
  sudo tailscaled --tun=userspace-networking > /dev/null 2>&1 &
fi
