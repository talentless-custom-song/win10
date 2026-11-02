#!/bin/bash
# Cai va bat Tailscale de lay IP 100.x.x.x cho app RDP tren iPhone
if ! command -v tailscale >/dev/null 2>&1; then
  curl -fsSL https://tailscale.com/install.sh | sh
fi

if ! pgrep tailscaled >/dev/null 2>&1; then
  sudo tailscaled --tun=userspace-networking > /dev/null 2>&1 &
  sleep 3
fi

sudo tailscale up
echo ""
echo "IP Tailscale cua Codespace:"
tailscale ip -4
