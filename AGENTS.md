# Agent notes — Windows 10 in Docker

## What this repo is
Not a web app. It is a thin wrapper around the prebuilt `dockurr/windows` image, which
runs a full Windows 10 QEMU virtual machine inside a container and exposes a web
console (noVNC-style page + install progress) on container port **8006**.

Files: `docker-compose.yml` (upstream, sized for a GitHub Codespace with nested
virtualization), `install.sh` / `start.sh` / `stop.sh` (Codespaces helpers).

## Sandbox setup (`docker-compose.base44.yml`)
The Base44 sandbox cannot run the upstream compose unchanged:

| Upstream | Sandbox | Why |
| --- | --- | --- |
| `/dev/kvm` device | `KVM=N` | The sandbox exposes **no `/dev/kvm`** and no `vmx`/`svm` CPU flags, so QEMU falls back to TCG software emulation (~10x slower). |
| `RAM_SIZE=8G` | `4G` | Host has ~7 GB total. |
| `DISK_SIZE=64G` | `32G` | ~41 GB free on `/`; the disk image is sparse but must fit. |
| port `8006:8006` | `3000:8006` | Port 3000 is the preview entry point. |
| — | `CPU_CORES=4` | Hard ceiling: the host has 4 cores and ~7 GB RAM in total, so 8 cores / 32 GB RAM are not available here. |
| `AUDIO` unset | `AUDIO=Y` | Adds an Intel HDA sound card and streams audio to the web console (the noVNC audio toggle stays disabled otherwise). |
| — | `ARGUMENTS=-accel tcg,tb-size=256` | Bigger TCG translation cache — the only genuine speed-up without KVM (default is 32 MB). `CPU_CORES=max` takes every logical core. |

`KVM=N` already makes dockur launch QEMU with `-accel tcg,thread=multi`, so
multi-threaded emulation needs no extra flag. Check the live args with:

```bash
docker exec windows ps -ef | grep [q]emu
```

**Recreating the container restarts the Windows installation**: QEMU loses the
installer session, and an incomplete `data.img` is recreated, so a restart during
setup starts the file-copy phase again. Change CPU/audio/argument settings *before*
a long install when possible.

Storage lives in the named volume `windows-data` (not `./windows`) so the VM disk
survives container recreation without polluting the repo.

## Black screen in the preview console
Two different causes, both handled here:

1. **The container is not running.** When Windows shuts down (e.g. after installing
   updates) QEMU exits with code 0, and the console on port 3000 disappears — the
   preview then shows a black frame. The compose file therefore uses
   `restart: unless-stopped`, which boots Windows again from the persisted
   `windows-data` volume instead of leaving the console offline.
2. **Windows is mid-boot or noVNC lost its socket** (phone locked, network blip).
   Under TCG the guest shows a black screen for a long time between the boot logo
   and the desktop; that is normal. If the page is stuck on "Connecting…", reload
   the preview page. Check what the guest actually renders with a QEMU screendump
   (no browser involved):

```bash
docker exec windows python3 -c '
import socket, time
s = socket.socket(socket.AF_UNIX); s.connect("/run/shm/monitor.sock"); s.settimeout(5)
time.sleep(0.4); s.recv(4096)
s.sendall(b"screendump /tmp/s.ppm\n"); time.sleep(1.5)'
docker exec windows ls -l /tmp/s.ppm   # ~3 MB at 1280x800 == a real full frame
```

A screendump is the cheapest way to tell a guest-side black screen (brightness ~0)
from a viewer-side disconnect (guest frame has content).

## Things to know
- There is no source to bind-mount — the app IS the prebuilt image. Edits are made to
  the compose file / container env only.
- First boot downloads the Windows 10 ISO (~6 GB) from Microsoft with `aria2c`, then
  boots the installer. Under TCG software emulation a full Windows 10 installation
  takes **many hours**, so a freshly booted stack shows "Downloading…" then
  "Starting…" / the installer for a long time. This is expected, not a hang.
- Microsoft serves the ISO to datacenter IPs intermittently; dockur logs
  "Microsoft blocked the automated download request" and retries through a different
  method — a successful download still follows.
- Ports 3389/tcp+udp are published for RDP once Windows is installed
  (user `admin`, password from `PASSWORD` in the compose file).

## Commands
```bash
docker compose -f docker-compose.base44.yml up -d --build   # start
docker compose -f docker-compose.base44.yml ps              # status
docker logs -f windows                                      # install/boot progress
curl -fsS -o /dev/null http://localhost:3000/               # 200 == console page up
```

## Verification
`curl -sS -o /dev/null -w '%{http_code}' http://localhost:3000/` must return `200`
and the page must render dockur's blue progress screen. The container healthcheck in
`docker-compose.base44.yml` probes that endpoint.
