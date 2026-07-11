# dotfiles

Personal Arch Linux setup — an encrypted btrfs system with **bootable snapshots**, plus the configs and scripts to reproduce it end to end.

## Quick start

Already have base Arch and your user? Bring up the whole userland in one command:

```bash
sudo pacman -S --needed git
git clone https://github.com/sudobytemebaby/dotfiles.git ~/dotfiles
cd ~/dotfiles
./scripts/install.sh
```

It installs paru, packages, stow'd configs, services, and system tweaks — idempotent, so rerun any time. Breakdown: [Dotfiles & scripts](docs/install/06-dotfiles-and-scripts.md).

## Full installation

Building a machine from scratch? Follow the staged, follow-along guide — a full-disk-encrypted (LUKS) btrfs install with bootable snapshots, one stage at a time:

### **→ [docs/install](docs/install/README.md)** — start here

| Part | Stages |
|------|--------|
| **Base OS** (live USB) | [1 Pre-installation](docs/install/01-pre-installation.md) · [2 Disk & filesystems](docs/install/02-disk-and-filesystems.md) · [3 Base system](docs/install/03-base-system.md) · [4 Bootloader & encryption](docs/install/04-bootloader-and-encryption.md) · [5 First boot](docs/install/05-first-boot.md) |
| **Userland** (booted) | [6 Dotfiles & scripts](docs/install/06-dotfiles-and-scripts.md) · [7 Snapshots](docs/install/07-snapshots.md) · [8 Performance](docs/install/08-performance.md) · [9 Development](docs/install/09-development.md) · [10 Desktop & services](docs/install/10-desktop-and-services.md) · [11 Security](docs/install/11-security.md) · [12 Maintenance](docs/install/12-maintenance.md) |

## What makes this setup notable

- **Encrypted btrfs with bootable snapshots** — `/boot` lives on btrfs and the ESP mounts at `/efi`, so every snapshot carries its own kernel and boots cleanly from the GRUB menu. See the [boot architecture](docs/install/README.md#boot-architecture).
- **Single password prompt** despite GRUB + initramfs both unlocking LUKS, via an embedded keyfile.
- **snapper + snap-pac** — an automatic pre/post snapshot around every `pacman` transaction, plus a light timeline net.

## Repo layout

- [`docs/install/`](docs/install/README.md) — the staged installation guide
- `scripts/` — automated userland setup (`install.sh` + numbered stages, package lists)
- [`PACKAGES.md`](PACKAGES.md) — annotated package inventory
- everything else — per-app config directories, symlinked into `$HOME` with GNU stow
