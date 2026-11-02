#!/bin/bash
# Xoa Windows cu va cai Windows 10 Lite moi.
# Dung: bash install.sh          (khong am thanh)
#       bash install.sh sound    (them card am thanh ao)
cd "$(dirname "$0")"

if [ ! -e /dev/kvm ]; then
  echo "LOI: khong co /dev/kvm. Hay doi Codespace sang may tu 4 core tro len."
  exit 1
fi

ARGS=""
if [ "$1" = "sound" ]; then
  ARGS="-device intel-hda -device hda-duplex"
  echo "Se bat card am thanh ao."
fi

if [ -d windows ] && [ -n "$(ls -A windows 2>/dev/null)" ]; then
  read -p "Se XOA Windows cu va cai Windows Lite moi. Tiep tuc? (y/N) " ans
  if [ "$ans" != "y" ]; then
    echo "Da huy."
    exit 0
  fi
fi

echo "WIN_ARGS=$ARGS" > .env

docker compose down 2>/dev/null
docker rm -f windows 2>/dev/null
sudo rm -rf windows
mkdir -p windows
docker compose up -d

echo ""
echo "Dang tai ISO Windows 10 Lite va cai dat."
echo "Xem tien trinh: docker logs -f windows   (Ctrl+C de thoat xem log)"
echo "Mo tab PORTS, bam cong 8006 de xem man hinh Windows."
echo "Neu hien man hinh Windows Setup thi cai tay: Install now, Custom, chon o dia trong, Next."
