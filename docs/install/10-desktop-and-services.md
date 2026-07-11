# Stage 10 — Desktop & services

[← Development](09-development.md) · [Index](README.md) · [Next: Security →](11-security.md)

> The desktop-facing pieces: containers, display manager, keyboard remapping, proxy, networking backends, printing/scanning, boot splash, and GRUB looks.

> Most of this is done for you by `scripts/04-services.sh` + `scripts/05-system.sh`. Each section notes what's automated; the manual commands are the fallback and the reference.

---

## 1. Docker

> Automated by `scripts/04-services.sh` + `scripts/05-system.sh`.

```bash
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"   # log out/in for the group to take effect
```

## 2. Display manager (LY)

> Automated by `scripts/04-services.sh`.

```bash
sudo systemctl enable ly.service
```

## 3. Kanata (keyboard remapping)

> Automated by `scripts/04-services.sh` + `scripts/05-system.sh`.

```bash
# uinput group + membership.
sudo groupadd -r uinput
sudo usermod -aG input,uinput "$USER"

# Expose /dev/uinput to the group.
sudo tee /etc/udev/rules.d/99-uinput.rules <<'EOF'
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
EOF
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo modprobe uinput

# Load uinput on every boot.
echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf

# Enable the user service shipped in dotfiles.
systemctl --user enable --now kanata.service
```

## 4. Xray (proxy)

```bash
# Drop your config at ~/.config/xray/xsn.json (the shipped unit points there).
mkdir -p ~/.config/xray

systemctl --user enable --now xray.service
```

## 5. NetworkManager backends: iwd + dnsmasq

> Automated by `scripts/05-system.sh`.

Two drop-ins: **iwd** as the Wi-Fi backend (replaces `wpa_supplicant`), and **dnsmasq** as a local caching DNS resolver on `127.0.0.1` (faster repeat lookups + per-connection split DNS).

```bash
sudo mkdir -p /etc/NetworkManager/conf.d

sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf <<'EOF'
[device]
wifi.backend=iwd
EOF

sudo tee /etc/NetworkManager/conf.d/dns.conf <<'EOF'
[main]
dns=dnsmasq
EOF

sudo systemctl restart NetworkManager
```

Do **not** enable `iwd.service` / `dnsmasq.service` directly — NetworkManager manages both. Saved Wi-Fi connections carry over automatically; if one glitches, reconnect once.

## 6. Printers and scanners

> `scripts/04-services.sh` enables `cups.socket` + `avahi-daemon.service`; `scripts/05-system.sh` adds you to `lp` and `scanner`. The `nsswitch.conf` edit below is the only manual bit.

```bash
# Printing (cups.socket is socket-activated — no idle daemon).
sudo systemctl enable --now cups.socket
# mDNS/DNS-SD so cups auto-discovers IPP printers on the LAN.
sudo systemctl enable --now avahi-daemon.service
# Queue + scanner access.
sudo usermod -aG lp,scanner "$USER"
```

**Required manual step** — make `*.local` names resolve via mDNS. Edit the `hosts:` line in `/etc/nsswitch.conf`:

```bash
sudoedit /etc/nsswitch.conf
```

```
hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
```

`mdns_minimal [NOTFOUND=return]` must sit **after** `mymachines` and **before** `dns` — otherwise `.local` lookups fall through to DNS and stall on NXDOMAIN.

Modern **IPP Everywhere** printers (anything since ~2015) then appear in `system-config-printer` with no driver. Older models need a brand driver: HP `hplip`, Epson `epson-inkjet-printer-escpr` (AUR), Brother `brlaser` (AUR), Samsung `splix`. To scan, launch `simple-scan` — SANE auto-detects most devices.

## 7. Plymouth boot splash

```bash
sudo pacman -S plymouth

# Add `plymouth` to HOOKS, BEFORE encrypt.
sudo nvim /etc/mkinitcpio.conf
# HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block plymouth encrypt filesystems fsck)

# Add `splash` to the kernel cmdline.
sudo nvim /etc/default/grub
# GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash ..."

# Theme.
paru -S plymouth-theme-spinner-alt-git
sudo plymouth-set-default-theme -l
sudo plymouth-set-default-theme -R spinner_alt

# Regenerate.
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkinitcpio -P
```

## 8. GRUB resolution & font

The GRUB menu can look low-res. Edit `/etc/default/grub`:

```bash
sudo nvim /etc/default/grub
# GRUB_GFXMODE=auto        # or an explicit resolution
```

Bigger / nicer font:

```bash
ls /usr/share/fonts/TTF/
sudo grub-mkfont -s 24 -o /boot/grub/fonts/[YOUR_FONT]24.pf2 /usr/share/fonts/TTF/[YOUR_FONT].ttf

sudo nvim /etc/default/grub
# GRUB_FONT=/boot/grub/fonts/[YOUR_FONT]24.pf2

sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---

**Next:** [Stage 11 — Security →](11-security.md)
