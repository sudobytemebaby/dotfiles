# Stage 2 — Disk & filesystems

[← Pre-installation](01-pre-installation.md) · [Index](README.md) · [Next: Base system →](03-base-system.md)

> Partition the disk, encrypt it with LUKS, lay out the btrfs subvolumes, and mount everything ready for the install.

> **⚠️ Data loss ahead.** These steps erase the target disk. Double-check every device name before you run anything.

Throughout, `/dev/[YOUR_DISK]` is a placeholder — replace it with your real disk. NVMe partitions are `p1`/`p2` (e.g. `nvme0n1p1`); SATA are `1`/`2` (e.g. `sda1`).

---

## 1. Identify your disk

```bash
# List all disks — find your main drive.
lsblk
fdisk -l
```

Common names: NVMe `→ /dev/nvme0n1`, SATA `→ /dev/sda`. **Write yours down and substitute it everywhere below.**

## 2. Partition the disk

```bash
# VERIFY THE DISK NAME FIRST!
lsblk

cfdisk /dev/[YOUR_DISK]
```

Create two partitions:

| Partition | Size | Type |
| --------- | ---- | ---- |
| `/dev/[YOUR_DISK]p1` | 512 MB | EFI System |
| `/dev/[YOUR_DISK]p2` | Remaining space | Linux filesystem |

In `cfdisk`:

1. Choose `gpt` if asked for a label type.
2. New partition → 512M → type **EFI System**.
3. New partition → remaining space → type **Linux filesystem**.
4. **Write** changes (type `yes`), then **Quit**.

## 3. Encrypt the root partition with LUKS

```bash
# DOUBLE-CHECK YOUR PARTITION NUMBER!
lsblk

# Format as LUKS2 with PBKDF2.
# Why --pbkdf pbkdf2: cryptsetup defaults to Argon2id, which GRUB can't unlock
# (or unlocks very slowly). Because our /boot is inside this encrypted volume,
# GRUB itself must open it at boot — so PBKDF2 is required here.
# You'll be asked to create a password — REMEMBER IT!
cryptsetup luksFormat --type luks2 --pbkdf pbkdf2 /dev/[YOUR_DISK]p2

# Open it. "cryptroot" is just a name — it appears as /dev/mapper/cryptroot.
cryptsetup open /dev/[YOUR_DISK]p2 cryptroot

# Confirm.
ls /dev/mapper/   # should list "cryptroot"
```

Type `YES` (capitals) to confirm the format, then enter your passphrase twice.

## 4. Create filesystems

```bash
# Format the EFI System Partition (ESP). It stays unencrypted and will be
# mounted at /efi (NOT /boot) — it holds only the GRUB EFI binary.
mkfs.fat -F32 /dev/[YOUR_DISK]p1

# Create btrfs on the encrypted device.
mkfs.btrfs -L Archlinux /dev/mapper/cryptroot
```

## 5. Create btrfs subvolumes

Subvolumes let us snapshot the system while excluding things we don't want in snapshots (logs, cache, temp).

```bash
# Mount the raw btrfs to create subvolumes.
mount /dev/mapper/cryptroot /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@pkg
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@snapshots

umount /mnt
```

What each is for:

- `@` — root filesystem (**`/boot` lives here**, so kernels get snapshotted)
- `@home` — your files
- `@log` — `/var/log` (excluded from root snapshots)
- `@pkg` — pacman cache (excluded, saves re-downloads on rollback)
- `@tmp` — `/tmp` (never snapshotted)
- `@snapshots` — where snapper stores snapshots

## 6. Mount everything

```bash
# Root subvolume, with SSD-optimized options.
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt

# Mount points. NOTE: /boot is a plain directory on @ (so it lands inside
# snapshots) — we do NOT mount anything there. /efi is where the ESP goes.
mkdir -p /mnt/{home,var/log,var/cache/pacman/pkg,tmp,.snapshots,boot,efi}

mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@log /dev/mapper/cryptroot /mnt/var/log
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@tmp /dev/mapper/cryptroot /mnt/tmp
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots

# Mount the ESP at /efi (NOT /boot).
mount /dev/[YOUR_DISK]p1 /mnt/efi

# Verify.
lsblk
```

Mount options: `noatime` (no access-time writes), `compress=zstd:3` (transparent compression), `ssd` (SSD tuning), `discard=async` (background TRIM), `space_cache=v2` (better free-space tracking).

> **Why `/efi` and not `/boot`?** If the ESP were mounted at `/boot`, the kernel would live on the FAT partition — *outside* the btrfs snapshots. Booting an old snapshot would then pair the newest kernel with that snapshot's older modules and fail. Keeping `/boot` on btrfs makes every snapshot self-contained and bootable.

---

**Next:** [Stage 3 — Base system →](03-base-system.md)
