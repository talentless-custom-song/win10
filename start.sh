#!/bin/bash
cd "$(dirname "$0")"
# Neu container da ton tai thi chi bat lai, chua co thi tao moi
docker start windows 2>/dev/null || docker compose up -d
