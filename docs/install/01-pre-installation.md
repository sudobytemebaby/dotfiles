# Stage 1 — Pre-installation

[Installation index](README.md) · [Next: Disk & filesystems →](02-disk-and-filesystems.md)

> Boot the Arch live USB, confirm you're in UEFI mode, get online, and sync the clock. Everything here runs from the live environment.

---

## 1. Boot from USB and verify UEFI mode

```bash
# This should list files if you booted in UEFI mode (which you want).
ls /sys/firmware/efi/efivars
```

If that directory is empty or missing, reboot and pick the **UEFI** entry for your USB stick in the firmware boot menu.

## 2. Adjust screen brightness (optional)

```bash
# Find your backlight device and its max value.
ls /sys/class/backlight/
cat /sys/class/backlight/*/max_brightness

# Set a comfortable level (adjust the path and value to your hardware).
echo 500 | sudo tee /sys/class/backlight/amdgpu_bl0/brightness
```

## 3. Connect to Wi-Fi

Skip this if you're on wired ethernet — it just works.

```bash
iwctl
# Inside the iwctl prompt:
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "YOUR_NETWORK_NAME"
exit

# Verify you're online.
ping -c 3 archlinux.org
```

## 4. Sync the system clock

```bash
timedatectl set-ntp 1
```

---

**Next:** [Stage 2 — Disk & filesystems →](02-disk-and-filesystems.md)
