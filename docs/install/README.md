# Arch Linux Installation

A staged, follow-along install for a **full-disk-encrypted (LUKS) btrfs** system with **bootable snapshots**. Work through the stages in order — each page ends with a link to the next.

New here? Read the [boot architecture](#boot-architecture) below first — it explains the few non-obvious choices (especially why `/boot` lives on btrfs and the ESP mounts at `/efi`).

## Stages

**Part 1 — Base OS** (run from the live USB)

| # | Stage | What you'll do |
|---|-------|----------------|
| 1 | [Pre-installation](01-pre-installation.md) | Boot the USB, verify UEFI, get online, sync the clock |
| 2 | [Disk & filesystems](02-disk-and-filesystems.md) | Partition, LUKS-encrypt, create btrfs subvolumes, mount |
| 3 | [Base system](03-base-system.md) | `pacstrap`, fstab, chroot, locale / hostname / root password |
| 4 | [Bootloader & encryption](04-bootloader-and-encryption.md) | GRUB, keyfile (single password prompt), initramfs, install |
| 5 | [First boot](05-first-boot.md) | Create your user, reboot, get online, fast mirrors |

**Part 2 — Userland** (run on the booted system)

| # | Stage | What you'll do |
|---|-------|----------------|
| 6 | [Dotfiles & scripts](06-dotfiles-and-scripts.md) | Clone dotfiles, run the automated setup |
| 7 | [Snapshots](07-snapshots.md) | snapper + snap-pac + grub-btrfs |
| 8 | [Performance](08-performance.md) | zram, earlyoom, auto-cpufreq |
| 9 | [Development](09-development.md) | SSH key, git, manual dotfiles |
| 10 | [Desktop & services](10-desktop-and-services.md) | Docker, LY, kanata, networking, printers, plymouth, GRUB looks |
| 11 | [Security](11-security.md) | UFW, SSH hardening, fail2ban |
| 12 | [Maintenance](12-maintenance.md) | Cache, journal, orphans, mirrors, checklist |

The annotated package inventory lives in [PACKAGES.md](../../PACKAGES.md).

## Boot architecture

This setup is built so that **btrfs snapshots are actually bootable**, which drives a few non-obvious choices:

- **`/boot` lives on the encrypted btrfs `@` subvolume**, not on the EFI partition. That way each snapshot captures its own kernel + initramfs + modules together, so booting an old snapshot never mismatches the kernel against its modules.
- **The EFI System Partition (ESP) is mounted at `/efi`** and holds only GRUB's EFI binary.
- Because `/boot` is inside LUKS, **GRUB itself unlocks the disk** to read the kernel. That's why we format LUKS with `--pbkdf pbkdf2` (GRUB can't do Argon2) and set `GRUB_ENABLE_CRYPTODISK=y`.
- To avoid typing the passphrase twice (once for GRUB, once for the initramfs), we embed a **keyfile** in the initramfs. You get a single password prompt.
- **`snap-pac`** takes an automatic pre/post snapshot around every `pacman` transaction — and since `/boot` is in the snapshot, those are bootable too.

## Conventions

- `/dev/[YOUR_DISK]` is a placeholder — replace it with your real disk (e.g. `nvme0n1`). NVMe partitions are `p1`/`p2`; SATA are `1`/`2`.
- Part 1 commands run in the live environment (some inside `arch-chroot`). Part 2 runs on your booted system as your user.

---

**Start:** [Stage 1 — Pre-installation →](01-pre-installation.md)
