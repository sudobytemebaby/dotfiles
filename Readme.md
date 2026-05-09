# Arch Linux Installation Guide

## Full Disk Encryption (LUKS) + Btrfs + Snapper

**Warning**: This guide involves disk partitioning and encryption. Double-check every command before running it. Data loss is permanent!

> **Already have a base Arch install and just want this setup rolled out?** Jump to [Automated setup scripts](#automated-setup-scripts). The annotated package list lives in [PACKAGES.md](./PACKAGES.md).

---

## Table of Contents

1. [Automated setup scripts](#automated-setup-scripts)
2. [Pre-Installation Setup](#pre-installation-setup)
3. [Disk Encryption & Partitioning](#disk-encryption--partitioning)
4. [Btrfs Subvolume Setup](#btrfs-subvolume-setup)
5. [Base System Installation](#base-system-installation)
6. [System Configuration](#system-configuration)
7. [Bootloader Setup](#bootloader-setup)
8. [User Management](#user-management)
9. [First Boot & Package Installation](#first-boot--package-installation)
10. [Snapshot Management with Snapper](#snapshot-management-with-snapper)
11. [Performance Optimization](#performance-optimization)
12. [Development Environment](#development-environment)
13. [Additional Services](#additional-services)
14. [Essential Security Setup](#essential-security-setup)
15. [System Maintenance](#system-maintenance)

---

## Automated setup scripts

Once the base Arch system is in place (after step 25 below, or on any other Arch box that already has your user), the entire userland can be brought up with a single command:

```bash
sudo pacman -S --needed git
cd ~ && git clone https://github.com/sudobytemebaby/dotfiles.git
cd dotfiles
./scripts/install.sh
```

Each step is broken down in [Step 29](#29-clone-dotfiles-and-run-the-install-scripts). The annotated package list lives in [PACKAGES.md](./PACKAGES.md).

The scripts are idempotent — you can rerun them. Steps can also be invoked individually:

```bash
./scripts/install.sh paru          # only paru
./scripts/install.sh packages      # only packages
./scripts/install.sh stow          # only configs
./scripts/install.sh services      # only systemd services
./scripts/install.sh system        # only system tweaks
```

What to customise:

- `scripts/pacman.txt` and `scripts/aur.txt` — package lists consumed by `02-packages.sh`
- `scripts/04-services.sh` — services listed in the `SYSTEM_SERVICES` and `USER_SERVICES` arrays
- `scripts/05-system.sh` — groups, udev, zram, iwd + dnsmasq backends for NetworkManager

After a full run, **reboot** to apply group changes, zram, and the iwd backend.

---

## Pre-Installation Setup

### 1. Boot from USB and Verify UEFI Mode

```bash
# This should show files if you're in UEFI mode (which you want!)
ls /sys/firmware/efi/efivars
```

### 2. Adjust Screen Brightness (if needed)

```bash
# First, find your backlight device and check the max brightness
ls /sys/class/backlight/
cat /sys/class/backlight/*/max_brightness

# Set brightness (replace with your actual path and desired value)
echo 500 | sudo tee /sys/class/backlight/amdgpu_bl0/brightness
```

### 3. Connect to WiFi

```bash
# Start the interactive WiFi tool
iwctl

# Inside iwctl, run these commands:
device list
station wlan0 scan
station wlan0 get-networks
station wlan0 connect "YOUR_NETWORK_NAME"
exit

# Test your connection
ping -c 3 google.com
```

### 4. Sync System Clock

```bash
timedatectl set-ntp 1
```

---

## Disk Encryption & Partitioning

**CRITICAL**: We're setting up full disk encryption. You'll need to enter a password every time you boot. Make it strong but memorable!

### 5. Identify Your Disk

```bash
# List all available disks - look for your main drive
lsblk
fdisk -l
```

**IMPORTANT**: Throughout this guide, we use `/dev/[YOUR_DISK]` as a placeholder. Common disk names:

- NVMe SSD: `/dev/nvme0n1`
- SATA SSD/HDD: `/dev/sda`
- Additional drives: `/dev/nvme1n1`, `/dev/sdb`, etc.

**Write down your actual disk name and replace `/dev/[YOUR_DISK]` with it in every command!**

### 6. Partition Your Disk

```bash
# VERIFY THE DISK NAME FIRST!
lsblk

# Open the partitioning tool for your disk
cfdisk /dev/[YOUR_DISK]
```

**Create these partitions:**

| Partition                                   | Size            | Type             |
| ------------------------------------------- | --------------- | ---------------- |
| `/dev/[YOUR_DISK]p1` or `/dev/[YOUR_DISK]1` | 512MB           | EFI System       |
| `/dev/[YOUR_DISK]p2` or `/dev/[YOUR_DISK]2` | Remaining space | Linux filesystem |

**Note**: NVMe drives use `p1`, `p2` (e.g., `nvme0n1p1`). SATA drives use `1`, `2` (e.g., `sda1`).

**In cfdisk:**

1. Select `gpt` if asked for label type
2. Create new partition: 512M, type: EFI System
3. Create new partition: Use remaining space, type: Linux filesystem
4. Write changes (type "yes" to confirm)
5. Quit

### 7. Setup LUKS Encryption

**This is where we encrypt your main partition:**

```bash
# DOUBLE CHECK YOUR PARTITION NUMBER!
lsblk

# Format the partition as LUKS2 with PBKDF2.
# Why --pbkdf pbkdf2: cryptsetup defaults to Argon2id, which older GRUB versions
# can't unlock at all and current GRUB unlocks slowly. PBKDF2 is faster on the
# unlock screen and works on every GRUB.
# You'll be asked to create a password — REMEMBER IT!
cryptsetup luksFormat --type luks2 --pbkdf pbkdf2 /dev/[YOUR_DISK]p2  # or /dev/[YOUR_DISK]2 for SATA
```

**Type `YES` (in capitals) to confirm, then enter your encryption password twice.**

```bash
# Open the encrypted partition (you'll enter your password)
# "cryptroot" is just a name - the decrypted partition will appear as /dev/mapper/cryptroot
cryptsetup open /dev/[YOUR_DISK]p2 cryptroot  # or /dev/[YOUR_DISK]2 for SATA

# Verify it's open
ls /dev/mapper/
# You should see "cryptroot" listed
```

### 8. Create Filesystems

```bash
# Format the EFI partition (the unencrypted boot partition)
mkfs.fat -F32 /dev/[YOUR_DISK]p1  # or /dev/[YOUR_DISK]1 for SATA

# Create btrfs filesystem on the encrypted partition
mkfs.btrfs -L Archlinux /dev/mapper/cryptroot
```

---

## Btrfs Subvolume Setup

**Why subvolumes?** They let you snapshot different parts of your system independently and exclude certain directories (like temporary files) from snapshots.

### 9. Create Subvolumes

```bash
# Mount the btrfs filesystem temporarily
mount /dev/mapper/cryptroot /mnt

# Create all our subvolumes
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@pkg
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@snapshots

# Unmount so we can remount with proper options
umount /mnt
```

**What each subvolume is for:**

- `@` - Your root filesystem (main system files)
- `@home` - Your personal files and settings
- `@log` - System logs (we don't need to snapshot these)
- `@pkg` - Pacman package cache (saves re-downloading)
- `@tmp` - Temporary files (definitely don't snapshot these!)
- `@snapshots` - Where snapper stores snapshots

### 10. Mount Everything with Optimal Settings

```bash
# Mount root subvolume with SSD-optimized options
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@ /dev/mapper/cryptroot /mnt

# Create all the mount point directories
mkdir -p /mnt/{home,var/log,var/cache/pacman/pkg,tmp,boot,.snapshots}

# Mount all the other subvolumes
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@log /dev/mapper/cryptroot /mnt/var/log
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@pkg /dev/mapper/cryptroot /mnt/var/cache/pacman/pkg
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@tmp /dev/mapper/cryptroot /mnt/tmp
mount -o noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvol=@snapshots /dev/mapper/cryptroot /mnt/.snapshots

# Mount the EFI boot partition
mount /dev/[YOUR_DISK]p1 /mnt/boot  # or /dev/[YOUR_DISK]1 for SATA

# Verify everything is mounted correctly
lsblk
```

**What those mount options mean:**

- `noatime` - Don't update access times (faster)
- `compress=zstd:3` - Compress files to save space
- `ssd` - SSD-specific optimizations
- `discard=async` - Helps with SSD wear leveling
- `space_cache=v2` - Better free space tracking

---

## Base System Installation

### 11. Update Keyring and Install Base System

```bash
# Refresh the keyring (avoids signature errors)
pacman -Sy archlinux-keyring

# Install the base system (this will take a few minutes)
pacstrap /mnt base base-devel \
    linux linux-firmware linux-headers \
    btrfs-progs snapper grub-btrfs \
    amd-ucode networkmanager iwd \
    grub efibootmgr os-prober \
    vim git \
    mesa vulkan-radeon libva-mesa-driver
```

**What we're installing:**

- Base system and kernel (`base`, `base-devel`, `linux*`)
- Btrfs tools and snapshot utilities
- AMD microcode and graphics drivers (swap `amd-ucode` for `intel-ucode` on Intel)
- Network management (`networkmanager` + `iwd` Wi-Fi backend)
- Bootloader (`grub`, `efibootmgr`, `os-prober`)
- A minimal in-chroot editor (`vim`) and `git` for cloning dotfiles after first boot

> Everything else lives in `scripts/pacman.txt` / `scripts/aur.txt` and is installed by `scripts/install.sh` after first boot. See [PACKAGES.md](./PACKAGES.md) for the annotated list.

### 12. Generate Filesystem Table

```bash
# Generate fstab (tells the system what to mount on boot)
genfstab -U /mnt >> /mnt/etc/fstab

# Good practice: check it looks right
cat /mnt/etc/fstab
```

### 13. Enter Your New System

```bash
# Chroot into the new installation
# From now on, commands run inside your new system
arch-chroot /mnt
```

---

## System Configuration

### 14. Set Timezone and Locale

```bash
# Set your timezone (adjust for your location!)
# Find yours with: ls /usr/share/zoneinfo/
ln -sf /usr/share/zoneinfo/Asia/Barnaul /etc/localtime

hwclock --systohc

# Pick locales (languages)
tee -a /etc/locale.gen <<'EOF'
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8
EOF
locale-gen
echo "LANG=en_US.UTF-8" | tee /etc/locale.conf

# Console keymap (loaded before the LUKS prompt only if it's also in mkinitcpio HOOKS)
echo "KEYMAP=us" | tee /etc/vconsole.conf
```

### 15. Set Hostname

```bash
# Choose your computer's name (replace with what you want)
echo "archlinux" | tee /etc/hostname

# Setup hosts file
tee -a /etc/hosts <<'EOF'
127.0.0.1   localhost
::1         localhost
127.0.1.1   archlinux.localdomain archlinux
EOF
```

**Replace `archlinux` with whatever name you chose!**

### 16. Set Root Password

```bash
# Set a password for the root user
passwd
```

---

## Bootloader Setup

**CRITICAL SECTION**: We need to configure GRUB to unlock your encrypted disk on boot.

### 17. Get Your Partition UUID

```bash
# Get the UUID of your encrypted partition
# Write this down or keep this terminal open!
blkid /dev/[YOUR_DISK]p2  # or /dev/[YOUR_DISK]2 for SATA
```

Copy the UUID value (it looks like: `a1b2c3d4-e5f6-...`)

### 18. Configure GRUB for Encryption

```bash
# Edit GRUB configuration
vim /etc/default/grub
```

**Find this line:**

```bash
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet"
```

**Change it to** (replace YOUR-UUID-HERE with the UUID you just copied):

```bash
GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet cryptdevice=UUID=YOUR-UUID-HERE:cryptroot root=/dev/mapper/cryptroot"
```

**Also in `/etc/default/grub`, uncomment this line:**

```bash
# Enables crypto stuff for grub
GRUB_ENABLE_CRYPTODISK=y
```

**And make sure this is uncommented:**

```bash
# That allows os-prober to find windows or whatever for other boot option
GRUB_DISABLE_OS_PROBER=false
```

### 19. Configure Initramfs for Encryption

```bash
# Edit mkinitcpio configuration
vim /etc/mkinitcpio.conf
```

**Find the MODULES line and change it to:**

```bash
MODULES=(btrfs)
```

**Find the HOOKS line and add `encrypt` before `filesystems`:**

```bash
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)
```

**This is super important!** The order matters:

- `encrypt` must come before `filesystems`
- `keyboard` and `keymap` must come before `encrypt`

Save and exit.

### 20. Rebuild Initramfs

```bash
# Generate the initramfs with our encryption settings
mkinitcpio -P
```

### 21. Install GRUB

```bash
# Install GRUB to the EFI partition
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck

# Generate GRUB configuration
grub-mkconfig -o /boot/grub/grub.cfg
```

**You should see a message about detecting your encrypted device!**

### 22. Fix /tmp Cleanup Issue

Because `/tmp` is its own subvolume, we need to tell the system to clean it on boot. We also mask the default `tmp.mount` so systemd doesn't try to overlay tmpfs on top of our subvolume.

```bash
# Clean /tmp on every boot (since fstab mounts a subvolume there).
mkdir -p /etc/tmpfiles.d
tee /etc/tmpfiles.d/tmp.conf <<'EOF'
# Clean /tmp directory on every boot
D! /tmp 1777 root root 0
EOF

# Stop systemd from mounting tmpfs over our btrfs /tmp.
systemctl mask tmp.mount
```

---

## User Management

### 23. Create Your User Account

```bash
# Create your user (replace USERNAME with your desired username)
useradd -m -G wheel,audio,video,optical,storage,input [USERNAME]

# Set password for your user
passwd [USERNAME]

# Give your user sudo privileges
EDITOR=vim visudo
```

**In the visudo editor, uncomment this line:**

```bash
%wheel ALL=(ALL:ALL) ALL
```

Save and exit (in vim: press `Esc`, type `:wq`, press `Enter`)

### 24. Enable NetworkManager

```bash
# Enable NetworkManager so you have internet after reboot
systemctl enable NetworkManager
```

### 25. Exit and Reboot

```bash
# Exit the chroot environment
exit

# Unmount everything
umount -R /mnt

# Reboot into your new system!
reboot
```

**Remove the USB stick when rebooting!**

**You'll now see:**

1. GRUB menu
2. Password prompt for disk decryption (enter your LUKS password)
3. Login prompt (login with your username and password)

---

## First Boot & Package Installation

Congratulations! You've installed Arch with encryption. Now let's set up everything else.

### 26. Connect to WiFi (if needed)

```bash
# Connect using NetworkManager
nmcli device wifi connect "YOUR_NETWORK_NAME" password "YOUR_PASSWORD"

# Test connection
ping -c 3 google.com
```

### 27. Setup Pacman Configuration

```bash
# Edit pacman configuration
sudo vim /etc/pacman.conf
```

**Uncomment or add these lines for a better experience:**

```bash
Color
ILoveCandy
ParallelDownloads = 10
```

Save and update:

```bash
sudo pacman -Syu
```

### 28. Setup Fast Mirrors with Reflector

```bash
# Install reflector
sudo pacman -S reflector

# Auto-pick the 20 freshest HTTPS mirrors and sort them by sync rate.
# No --country: let the global mirror pool win on ping/rate.
# Add e.g. --country DE,FR,NL if you want to constrain by region.
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Enable automatic mirror updates
sudo systemctl enable --now reflector.timer
```

### 29. Clone dotfiles and run the install scripts

From here on the remaining work is automated by the scripts in `scripts/`. For a higher-level overview see the **Automated setup scripts** section above and `PACKAGES.md`.

```bash
# Install git first if it isn't there yet
sudo pacman -S --needed git

# Clone dotfiles into your home directory
cd ~
git clone https://github.com/sudobytemebaby/dotfiles.git
cd dotfiles

# Run the full setup (paru + packages + stow + services + system tweaks)
./scripts/install.sh
```

**What `scripts/install.sh` does:**

1. `01-paru.sh` — installs paru-bin from the AUR
2. `02-packages.sh` — `paru -S` for everything in `scripts/pacman.txt` and `scripts/aur.txt`
3. `03-stow.sh` — symlinks every dotfiles directory into `$HOME` via stow
4. `04-services.sh` — enables systemd services (NetworkManager, ly, docker, snapper timers, kanata, etc.)
5. `05-system.sh` — adds you to groups (docker, input, uinput, libvirt), installs the kanata udev rule, configures zram, switches NetworkManager to iwd + dnsmasq, sets up tmpfiles for /tmp

Individual steps can be run too: `./scripts/install.sh stow services`.

**Note**: the first run takes a while — AUR builds plus ~150 packages from the repos. When it finishes, `reboot` to apply group changes, zram, and iwd.

## Snapshot Management with Snapper

**This is where the magic happens - automated system snapshots!**

### 30. Initial Snapper Setup

```bash
# Verify your btrfs subvolumes
btrfs subvolume list /
```

You should see your subvolumes including `@snapshots`.

### 31. Create Snapper Config

**This is tricky because .snapshots already exists. Here's the fix:**

```bash
# 1. Temporarily unmount @snapshots
sudo umount /.snapshots

# 2. Remove the directory
sudo rmdir /.snapshots

# 3. Create snapper config (this works now!)
sudo snapper -c root create-config /

# 4. Delete the subvolume snapper just created (we want our @snapshots)
sudo btrfs subvolume delete /.snapshots

# 5. Recreate the directory
sudo mkdir /.snapshots

# 6. Mount our proper @snapshots
sudo mount /.snapshots

# 7. Let your wheel-group user manage snapshots without sudo.
sudo snapper -c root set-config "ALLOW_GROUPS=wheel"
sudo snapper -c root set-config "SYNC_ACL=yes"
sudo chown :wheel /.snapshots
sudo chmod 750 /.snapshots

# 8. Verify everything works
snapper -c root list
```

### 32. Configure Snapper Settings

```bash
# Edit snapper configuration
sudo vim /etc/snapper/configs/root
```

**Change these values:**

```bash
# Timeline creation
TIMELINE_CREATE="yes"
TIMELINE_MIN_AGE="1800"          # Create snapshots max every 30 min

# How many snapshots to keep
TIMELINE_LIMIT_HOURLY="12"       # Last 12 hours
TIMELINE_LIMIT_DAILY="7"         # Last 7 days
TIMELINE_LIMIT_WEEKLY="4"        # Last 4 weeks
TIMELINE_LIMIT_MONTHLY="3"       # Last 3 months
TIMELINE_LIMIT_YEARLY="0"        # No yearly snapshots

# Safety limits
NUMBER_LIMIT="30"                # Never exceed 30 snapshots
NUMBER_LIMIT_IMPORTANT="10"      # Keep up to 10 manual snapshots

# Cleanup settings
TIMELINE_CLEANUP="yes"
NUMBER_CLEANUP="yes"
EMPTY_PRE_POST_CLEANUP="yes"
EMPTY_PRE_POST_MIN_AGE="1800"

# Performance
BACKGROUND_COMPARISON="yes"
SYNC_ACL="yes"
```

### 33. Configure GRUB-Btrfs

```bash
# Edit grub-btrfs config
sudo vim /etc/default/grub-btrfs/config
```

**Add these lines:**

```bash
GRUB_BTRFS_SUBMENUNAME="Arch Snapshots"
GRUB_BTRFS_LIMIT="30"
```

### 34. Enable Snapshot Services

```bash
# Enable automatic snapshots
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# Enable automatic GRUB updates (so snapshots appear in boot menu)
sudo systemctl enable --now grub-btrfsd.service

# Create your first snapshot!
sudo snapper -c root create --description "Fresh Installation"

# Check it worked
sudo snapper -c root list
```

---

## Performance Optimization

### 35. Setup Zram (Compressed RAM Swap)

```bash
# Configure zram
sudo tee /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF

# Enable it
sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service
```

### 36. Enable EarlyOOM (Prevents System Freezes)

```bash
# Enable EarlyOOM (already installed from script)
sudo systemctl enable --now earlyoom
```

### 37. Enable Auto-CPUFreq (Battery Life)

```bash
# Enable auto-cpufreq (already installed from script)
sudo systemctl enable --now auto-cpufreq
```

### 38. Check Boot Performance

```bash
# See how long your system takes to boot
systemd-analyze

# See what's taking time during boot
systemd-analyze blame
```

---

## Development Environment

### 39. Setup SSH Key

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Display public key (add this to GitHub)
cat ~/.ssh/id_ed25519.pub
```

**Add the key to GitHub:** https://github.com/settings/keys

### 40. Configure Git

```bash
# Set your name and email
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"

# Better git output
git config --global color.ui auto
git config --global init.defaultBranch main
```

### 41. Setup Dotfiles (manual alternative)

> Already handled by `scripts/03-stow.sh` if you ran `scripts/install.sh`. Use this only if you skipped the automated path.

```bash
# Clone your dotfiles
cd ~
git clone git@github.com:sudobytemebaby/dotfiles.git
cd dotfiles

# Use stow to symlink configs (skip the scripts/ directory).
stow --target="$HOME" $(ls -d */ | grep -v '^scripts/$' | tr -d /)
```

---

## Additional Services

### 42. Enable Docker (manual alternative)

> Already handled by `scripts/04-services.sh` + `scripts/05-system.sh`.

```bash
# Enable Docker service
sudo systemctl enable --now docker

# Add your user to the docker group (so you don't need sudo)
sudo usermod -aG docker "$USER"

# Log out and back in for the group change to take effect.
```

### 43. Setup Display Manager (LY) (manual alternative)

> Already handled by `scripts/04-services.sh`.

```bash
sudo systemctl enable ly.service
```

### 44. Configure Kanata (Keyboard Remapping) (manual alternative)

> Already handled by `scripts/04-services.sh` + `scripts/05-system.sh`.

```bash
# Create the uinput group, add yourself to it.
sudo groupadd -r uinput
sudo usermod -aG input,uinput "$USER"

# udev rule that exposes /dev/uinput to the uinput group.
sudo tee /etc/udev/rules.d/99-uinput.rules <<'EOF'
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
EOF
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo modprobe uinput

# Make uinput load on every boot.
echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf

# Enable the user service shipped from dotfiles.
systemctl --user enable --now kanata.service
```

### 45. Enabling Xray (Proxy)

```bash
# Drop your xray config in here as ~/.config/xray/xsn.json
# (the user unit shipped in dotfiles points at that exact path).
mkdir -p ~/.config/xray

# Then enable the user service stowed from dotfiles.
systemctl --user enable --now xray.service
```

### 46. NetworkManager backends: iwd + dnsmasq (manual alternative)

> Already handled by `scripts/05-system.sh`.

Two drop-ins under `/etc/NetworkManager/conf.d/`:

- **iwd** as the Wi-Fi backend (replaces `wpa_supplicant`).
- **dnsmasq** as the DNS backend — NetworkManager spawns a local caching resolver on `127.0.0.1`, which gives faster repeat lookups and per-connection split DNS.

```bash
sudo mkdir -p /etc/NetworkManager/conf.d

# Wi-Fi backend → iwd
sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf <<'EOF'
[device]
wifi.backend=iwd
EOF

# DNS backend → dnsmasq (local caching resolver)
sudo tee /etc/NetworkManager/conf.d/dns.conf <<'EOF'
[main]
dns=dnsmasq
EOF

# Reload NetworkManager to pick the new backends up.
sudo systemctl restart NetworkManager
```

Do not enable `iwd.service` or `dnsmasq.service` directly — NetworkManager starts and manages both itself. Reboot afterwards if anything looks off.

**Heads up:** existing saved Wi-Fi connections in NetworkManager carry over automatically. If something glitches, reconnect once — NetworkManager keeps the passwords and just hands them to iwd now.

### 47. Printers and scanners

> Mostly handled by `scripts/04-services.sh` (enables `cups.socket` + `avahi-daemon.service`) and `scripts/05-system.sh` (adds you to `lp` and `scanner`). The `nsswitch.conf` edit below is the only manual bit.

If you skipped the scripts, here's the manual sequence:

```bash
# Enable printing. cups.socket is socket-activated — it only spawns cupsd
# when something actually hits port 631, so there's no idle daemon.
sudo systemctl enable --now cups.socket

# Enable mDNS/DNS-SD so cups can auto-discover IPP printers on the LAN.
sudo systemctl enable --now avahi-daemon.service

# Allow your user to manage print queues and use the scanner.
sudo usermod -aG lp,scanner "$USER"
```

**Manual step (required even after running the scripts):** make `*.local` Bonjour hostnames resolve via mDNS. Edit the `hosts:` line in `/etc/nsswitch.conf`:

```bash
sudoedit /etc/nsswitch.conf
```

Change the `hosts:` line to:

```
hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
```

`mdns_minimal [NOTFOUND=return]` must sit **before** `dns` and **after** `mymachines`. `[NOTFOUND=return]` tells NSS "if mdns can't resolve a `.local` name, stop here" — otherwise the lookup falls through to DNS, which slowly returns NXDOMAIN.

After this, modern **IPP Everywhere** printers (basically anything sold since ~2015) appear in `system-config-printer` automatically — no driver needed. For older / non-IPP printers, install a brand-specific driver:

- HP: `hplip` (large — ~200 MB; only worth it if you actually have HP)
- Epson: `epson-inkjet-printer-escpr` (AUR)
- Brother laser: `brlaser` (AUR)
- Samsung SPL: `splix`

To scan, plug the scanner in and launch `simple-scan`. SANE auto-detects most USB and network scanners — no further configuration needed.

### 48. Setting up Plymouth with a custom theme

```bash
# Install plymouth.
sudo pacman -S plymouth

# Add plymouth to the mkinitcpio HOOKS line, before encrypt.
sudo nvim /etc/mkinitcpio.conf
# HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block plymouth encrypt filesystems fsck)

# Add `splash` to the kernel cmdline.
sudo nvim /etc/default/grub
# GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash ..."

# Install a theme.
paru -S plymouth-theme-spinner-alt-git

# List installed themes and apply the one you want.
sudo plymouth-set-default-theme -l
sudo plymouth-set-default-theme -R spinner_alt

# Regenerate grub config and initramfs.
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkinitcpio -P
```

### 49. Grub resolution fix

Your GRUB menu can look low-res by default. To fix it:

```bash
# Edit the grub config with your editor of choice.
sudo nvim /etc/default/grub
```

Set:

```bash
# Pick an explicit resolution, or leave 'auto' if it works for you.
GRUB_GFXMODE=auto
```

**You can also bump the font size (or swap fonts entirely):**

```bash
# Pick a font you like.
ls /usr/share/fonts/TTF/

# Convert it to GRUB's pf2 format at size 24 (try 32, 36 — whatever feels right).
sudo grub-mkfont -s 24 -o /boot/grub/fonts/[YOUR_FONT]24.pf2 /usr/share/fonts/TTF/[YOUR_FONT].ttf
```

- `-s 24` — font size
- `-o /boot/grub/fonts/[YOUR_FONT]24.pf2` — where the new font is saved

Wire the new font into GRUB:

```bash
sudo nvim /etc/default/grub
# Add or modify:
# GRUB_FONT=/boot/grub/fonts/[YOUR_FONT]24.pf2

# Regenerate the config and reboot.
sudo grub-mkconfig -o /boot/grub/grub.cfg
reboot
```

## Essential Security Setup

Your system is encrypted, which is great. The steps below add a few more layers.

> `ufw` and `arch-audit` are already in [PACKAGES.md](./PACKAGES.md) and `scripts/pacman.txt`. `fail2ban` and `openssh` are not — install them ad-hoc if you need them.

### 50. Install Security Essentials

```bash
# ufw and arch-audit come from your package list. Add fail2ban / openssh
# only if you actually need them.
sudo pacman -S --needed ufw arch-audit
# sudo pacman -S --needed fail2ban openssh
```

### 51. Setup Firewall (UFW)

UFW (Uncomplicated Firewall) is the easiest way to manage iptables.

```bash
# Enable UFW
sudo systemctl enable --now ufw

# Set default policies (deny all incoming, allow all outgoing)
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH if you use it (otherwise you'll lock yourself out remotely!)
sudo ufw allow ssh
# Or specify a custom SSH port if you changed it:
# sudo ufw allow 2222/tcp

# Allow other services you might need:
# sudo ufw allow 80/tcp      # HTTP
# sudo ufw allow 443/tcp     # HTTPS
# sudo ufw allow 8080/tcp    # Development server

# Enable the firewall
sudo ufw enable

# Check status
sudo ufw status verbose
```

**Inspecting UFW:**

```bash
# List all rules
sudo ufw status numbered

# Delete a rule by number if needed
sudo ufw delete [number]

# Disable UFW temporarily if something breaks
sudo ufw disable
```

### 52. Harden SSH Configuration

Only relevant if you actually run sshd (`openssh` is not installed by default).

```bash
# Backup the original config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Edit SSH config
sudoedit /etc/ssh/sshd_config
```

**Add or modify these lines:**

```bash
# Disable root login (use your user + sudo instead)
PermitRootLogin no

# Use SSH keys only, disable password authentication
PasswordAuthentication no
PubkeyAuthentication yes

# Disable empty passwords
PermitEmptyPasswords no

# Limit authentication attempts
MaxAuthTries 3

# Disconnect if no successful login within 30 seconds
LoginGraceTime 30

# Disable X11 forwarding if you don't need it
X11Forwarding no

# Use only strong ciphers and MACs
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com

# Optional: Change default port (security through obscurity, but reduces log noise)
# Port 2222

# Optional: Limit which users can SSH
# AllowUsers yourusername
```

**Apply the changes:**

```bash
# Validate the config first.
sudo sshd -t

# Restart sshd.
sudo systemctl restart sshd
```

**CRITICAL**: open a second SSH session and confirm it works before closing the current one.

### 53. Setup Fail2Ban

Fail2Ban automatically bans IPs that show malicious signs (too many password failures, etc.). Install `fail2ban` first if you didn't already.

```bash
# Create local override (don't edit jail.conf — it gets overwritten on update).
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudoedit /etc/fail2ban/jail.local
```

**Find and modify these sections:**

```ini
[DEFAULT]
# Ban for 1 hour
bantime = 3600

# Check for failures over 10 minutes
findtime = 600

# Ban after 5 failures
maxretry = 5

# Email notifications (optional)
# destemail = your@email.com
# sendername = Fail2Ban
# action = %(action_mwl)s

[sshd]
enabled = true
port = ssh
# If you changed SSH port:
# port = 2222
```

**Enable and start Fail2Ban:**

```bash
sudo systemctl enable --now fail2ban

# Status overview.
sudo fail2ban-client status

# SSH jail specifically.
sudo fail2ban-client status sshd

# Unban an IP if you accidentally locked yourself out.
sudo fail2ban-client set sshd unbanip [IP_ADDRESS]
```

---

## System Maintenance

A handful of timers and habits to keep the system tidy over time.

### 54. Install Maintenance Tools

```bash
# pacman-contrib and tldr are already in scripts/pacman.txt.
# Add the docs packages if you want offline man pages.
sudo pacman -S --needed pkgfile man-db man-pages
```

### 55. Setup Automatic Pacman Cache Cleaning

The package cache in `/var/cache/pacman/pkg/` grows over time.

```bash
# Inspect current size.
du -sh /var/cache/pacman/pkg/

# Clean manually (keeps last 3 versions of each package).
sudo paccache -r

# Drop everything for packages you no longer have installed.
sudo paccache -ruk0
```

**Automate it (handled by `scripts/04-services.sh` already):**

```bash
sudo systemctl enable --now paccache.timer
systemctl list-timers paccache.timer
```

### 56. Setup Journal Log Rotation

Systemd journals can grow unbounded.

```bash
# Inspect current size.
journalctl --disk-usage

# Edit limits.
sudoedit /etc/systemd/journald.conf
```

**Modify these lines:**

```ini
[Journal]
SystemMaxUse=500M
SystemMaxFileSize=50M
MaxRetentionSec=2weeks
```

**Apply changes:**

```bash
sudo systemctl restart systemd-journald

# Manually trim old logs if needed.
sudo journalctl --vacuum-size=500M
sudo journalctl --vacuum-time=2weeks
```

### 57. Setup Orphaned Package Cleanup

Remove packages that were pulled in as dependencies but no longer have a parent.

```bash
# List orphans (no output == nothing to do).
pacman -Qtdq

# Remove them safely (handles the empty-list case).
pacman -Qtdq | sudo pacman -Rns - 2>/dev/null || echo "no orphans"
```

### 58. Update Mirrorlist Regularly

Keep your mirrors fresh.

```bash
# reflector.timer was enabled in step 28; this just confirms it.
systemctl status reflector.timer
systemctl list-timers reflector.timer

# Manual refresh.
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

### 59. Maintenance Checklist

**Daily:**

- Btrfs snapshots (snapper)
- Security audit check (`arch-audit`)

**Weekly:**

- Package cache cleanup (`paccache.timer`)
- Journal log rotation
- TRIM (`fstrim.timer`, if you enable it)
- Orphan removal

**Monthly:**

- Mirror list refresh (`reflector.timer` does this automatically)

---

**That's it.** You now have a fully encrypted Arch Linux system with automatic snapshots, the userland from `scripts/install.sh`, and the full annotated package inventory in [PACKAGES.md](./PACKAGES.md).

Habits worth keeping:

- Take a manual snapshot before risky upgrades — `snapper -c root create -d "before X"`
- Rerun `./scripts/install.sh` after editing `scripts/pacman.txt` / `scripts/aur.txt` to keep the system in sync
- Boot into a snapshot from the GRUB menu now and then to make sure recovery actually works
