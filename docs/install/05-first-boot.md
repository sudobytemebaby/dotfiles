# Stage 5 — First boot

[← Bootloader & encryption](04-bootloader-and-encryption.md) · [Index](README.md) · [Next: Dotfiles & scripts →](06-dotfiles-and-scripts.md)

> Create your user, enable networking, reboot into the installed system, then get online and set up fast mirrors.

---

## 1. Create your user account

Still inside the chroot:

```bash
# Create the user (replace USERNAME).
useradd -m -G wheel,audio,video,optical,storage,input USERNAME
passwd USERNAME

# Grant sudo via the wheel group.
EDITOR=vim visudo
```

In `visudo`, uncomment:

```bash
%wheel ALL=(ALL:ALL) ALL
```

## 2. Enable NetworkManager

```bash
systemctl enable NetworkManager
```

## 3. Exit and reboot

```bash
exit            # leave the chroot
umount -R /mnt
reboot
```

**Remove the USB stick.** On boot you'll get: the GRUB menu → a LUKS password prompt → your login. If the password prompt shows only once, the keyfile is doing its job.

---

*Everything below runs on your booted system, as your user.*

## 4. Connect to Wi-Fi

```bash
nmcli device wifi connect "YOUR_NETWORK_NAME" password "YOUR_PASSWORD"
ping -c 3 archlinux.org
```

## 5. Pacman configuration

```bash
sudo vim /etc/pacman.conf
```

Uncomment / add for a nicer experience:

```ini
Color
ILoveCandy
ParallelDownloads = 10
```

Then:

```bash
sudo pacman -Syu
```

## 6. Fast mirrors with reflector

```bash
sudo pacman -S reflector

# Pick the 20 freshest HTTPS mirrors, sorted by sync rate.
# Add e.g. --country DE,FR,NL to constrain by region.
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Keep them fresh automatically.
sudo systemctl enable --now reflector.timer
```

---

**Next:** [Stage 6 — Dotfiles & scripts →](06-dotfiles-and-scripts.md)
