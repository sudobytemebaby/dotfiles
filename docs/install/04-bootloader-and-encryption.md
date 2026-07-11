# Stage 4 — Bootloader & encryption

[← Base system](03-base-system.md) · [Index](README.md) · [Next: First boot →](05-first-boot.md)

> The heart of the setup: configure GRUB to unlock LUKS, create a keyfile so you only type your passphrase once, build the initramfs, install GRUB, and fix `/tmp`. Still inside `arch-chroot`.

Because `/boot` lives inside the encrypted volume, **GRUB unlocks the disk itself** to read the kernel — then the initramfs unlocks it again for the real boot. The keyfile below collapses those two prompts into one. (See the [boot architecture](README.md#boot-architecture).)

---

## 1. Get your LUKS partition UUID

```bash
# UUID of the ENCRYPTED partition (p2). Keep this terminal open — you'll paste it next.
blkid /dev/[YOUR_DISK]p2
```

Copy the `UUID="…"` value (looks like `a1b2c3d4-e5f6-…`).

## 2. Configure GRUB for encryption

```bash
vim /etc/default/grub
```

Change the default command line (paste your UUID in place of `YOUR-UUID-HERE`):

```bash
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=YOUR-UUID-HERE:cryptroot root=/dev/mapper/cryptroot cryptkey=rootfs:/crypto_keyfile.bin"
```

`cryptkey=rootfs:/crypto_keyfile.bin` tells the initramfs to unlock root from the embedded keyfile (created in step 3) instead of prompting a second time.

Uncomment / set these two lines as well:

```bash
# REQUIRED: /boot is inside LUKS, so GRUB must unlock the disk to read the kernel.
GRUB_ENABLE_CRYPTODISK=y

# Lets os-prober add other OSes (e.g. Windows) to the menu.
GRUB_DISABLE_OS_PROBER=false
```

## 3. Create the keyfile, then configure the initramfs

**Create the keyfile** so you only type your passphrase once. It's embedded in the initramfs, which lives on the *encrypted* `/boot`, so it never leaves the encrypted volume.

```bash
# Random keyfile inside the (encrypted) root.
dd bs=512 count=4 if=/dev/random of=/crypto_keyfile.bin
chmod 600 /crypto_keyfile.bin

# Register it as an additional LUKS key (enter your existing passphrase once).
cryptsetup luksAddKey /dev/[YOUR_DISK]p2 /crypto_keyfile.bin
```

**Now edit the initramfs config:**

```bash
vim /etc/mkinitcpio.conf
```

Set these three lines:

```bash
MODULES=(btrfs)
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
FILES=(/crypto_keyfile.bin)
```

Order matters in `HOOKS`: `encrypt` must come **before** `filesystems`, and `keyboard`/`keymap` must come **before** `encrypt`.

## 4. Rebuild the initramfs

```bash
mkinitcpio -P

# The initramfs now embeds the keyfile — lock down its permissions.
chmod 600 /boot/initramfs-linux*.img
```

## 5. Install GRUB

```bash
# --efi-directory points at the ESP (/efi); GRUB's modules and config go to
# /boot/grub on btrfs. Because /boot is on LUKS, grub-install automatically
# embeds the cryptodisk/luks2/btrfs modules and the LUKS UUID.
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB --recheck

grub-mkconfig -o /boot/grub/grub.cfg
```

You should see a message about detecting your encrypted device.

## 6. Fix `/tmp` cleanup

`/tmp` is its own subvolume, so tell systemd to clean it on boot and stop it from overlaying tmpfs on top.

```bash
mkdir -p /etc/tmpfiles.d
tee /etc/tmpfiles.d/tmp.conf <<'EOF'
# Clean /tmp directory on every boot
D! /tmp 1777 root root 0
EOF

systemctl mask tmp.mount
```

---

**Next:** [Stage 5 — First boot →](05-first-boot.md)
