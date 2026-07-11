# Stage 6 — Dotfiles & scripts

[← First boot](05-first-boot.md) · [Index](README.md) · [Next: Snapshots →](07-snapshots.md)

> Bring up the entire userland — packages, configs, services, system tweaks — with the automated scripts. This is also the entry point for rolling the setup onto any other Arch box that already has your user.

---

## 1. Clone and run

```bash
sudo pacman -S --needed git
cd ~
git clone https://github.com/sudobytemebaby/dotfiles.git
cd dotfiles

# Full setup: paru + packages + stow + services + system tweaks.
./scripts/install.sh
```

## 2. What `scripts/install.sh` does

| Script | Purpose |
|--------|---------|
| `01-paru.sh` | Install `paru-bin` from the AUR |
| `02-packages.sh` | `paru -S` everything in `scripts/pacman.txt` + `scripts/aur.txt` |
| `03-stow.sh` | Symlink every dotfiles directory into `$HOME` via stow |
| `04-services.sh` | Enable systemd services (NetworkManager, ly, docker, snapper timers, grub-btrfsd, kanata, …) |
| `05-system.sh` | Groups (docker, input, uinput, libvirt), kanata udev rule, zram, NetworkManager iwd + dnsmasq backends, `/tmp` tmpfiles |

The scripts are **idempotent** — rerun any time. Run stages individually too:

```bash
./scripts/install.sh paru          # only paru
./scripts/install.sh packages      # only packages
./scripts/install.sh stow          # only configs
./scripts/install.sh services      # only systemd services
./scripts/install.sh system        # only system tweaks
# or combine: ./scripts/install.sh stow services
```

## 3. What to customise

- `scripts/pacman.txt` / `scripts/aur.txt` — package lists (see [PACKAGES.md](../../PACKAGES.md))
- `scripts/04-services.sh` — the `SYSTEM_SERVICES` / `USER_SERVICES` arrays
- `scripts/05-system.sh` — groups, udev, zram, NetworkManager backends

> The first run takes a while — AUR builds plus ~150 repo packages. When it finishes, **reboot** to apply group changes, zram, and the iwd backend.

---

**Next:** [Stage 7 — Snapshots →](07-snapshots.md)
