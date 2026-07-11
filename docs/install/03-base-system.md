# Stage 3 — Base system

[← Disk & filesystems](02-disk-and-filesystems.md) · [Index](README.md) · [Next: Bootloader & encryption →](04-bootloader-and-encryption.md)

> Install the base packages, generate the filesystem table, chroot into the new system, and set locale, hostname, and the root password.

---

## 1. Install the base system

```bash
# Refresh the keyring first (avoids signature errors).
pacman -Sy archlinux-keyring

# Install the base system (takes a few minutes).
pacstrap /mnt base base-devel \
    linux linux-firmware linux-headers \
    btrfs-progs snapper snap-pac grub-btrfs \
    amd-ucode networkmanager iwd \
    grub efibootmgr os-prober \
    vim git \
    mesa vulkan-radeon libva-mesa-driver
```

What this pulls in:

- Base system + kernel (`base`, `base-devel`, `linux*`)
- Snapshot stack: `snapper` + `snap-pac` (auto pre/post pacman snapshots) + `grub-btrfs` (snapshots in the boot menu)
- AMD microcode + graphics (swap `amd-ucode` → `intel-ucode` and the mesa drivers on Intel)
- Networking (`networkmanager` + `iwd` Wi-Fi backend)
- Bootloader (`grub`, `efibootmgr`, `os-prober`)
- A minimal in-chroot editor (`vim`) and `git`

> Everything else is installed later by `scripts/install.sh` from `scripts/pacman.txt` / `scripts/aur.txt`. See [PACKAGES.md](../../PACKAGES.md).

## 2. Generate the filesystem table

```bash
genfstab -U /mnt >> /mnt/etc/fstab

# Sanity-check it: you should see the @ subvolumes and the ESP at /efi.
# There should be NO separate line for /boot — it's just a directory on @.
cat /mnt/etc/fstab
```

## 3. Enter the new system

```bash
# From here on, commands run inside your new install.
arch-chroot /mnt
```

## 4. Timezone and locale

```bash
# Timezone (find yours: ls /usr/share/zoneinfo/).
ln -sf /usr/share/zoneinfo/Asia/Barnaul /etc/localtime
hwclock --systohc

# Locales.
tee -a /etc/locale.gen <<'EOF'
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF
locale-gen
echo "LANG=en_US.UTF-8" | tee /etc/locale.conf

# Console keymap (also needs to be in the mkinitcpio HOOKS to apply at the LUKS prompt).
echo "KEYMAP=us" | tee /etc/vconsole.conf
```

## 5. Hostname

```bash
echo "archlinux" | tee /etc/hostname   # pick your own name

tee -a /etc/hosts <<'EOF'
127.0.0.1   localhost
::1         localhost
127.0.1.1   archlinux.localdomain archlinux
EOF
```

Replace `archlinux` with whatever name you chose (in both files).

## 6. Root password

```bash
passwd
```

---

**Next:** [Stage 4 — Bootloader & encryption →](04-bootloader-and-encryption.md)
