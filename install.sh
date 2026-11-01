#!/bin/bash
cd "$(dirname "$0")"

if [ ! -e /dev/kvm ]; then
  echo "LOI: khong co /dev/kvm. Hay doi Codespace sang may tu 4 core tro len."
  exit 1
fi

mkdir -p windows
docker compose up -d

echo ""
echo "Dang cai Windows 10 kem card am thanh ao."
echo "Xem tien trinh: docker logs -f windows"
echo "Mo tab PORTS, bam cong 8006 de xem man hinh Windows."
echo "Lan dau cai mat khoang 10 den 20 phut."
