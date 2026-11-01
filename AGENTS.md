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

Storage lives in the named volume `windows-data` (not `./windows`) so the VM disk
survives container recreation without polluting the repo.

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
