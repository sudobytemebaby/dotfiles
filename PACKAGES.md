# Packages

The full list of packages used by this setup, grouped by category. The flat lists consumed by the install script live in `scripts/pacman.txt` (official repositories) and `scripts/aur.txt` (AUR). When you add or remove something, edit both this file and the matching `.txt`.

Legend:

- `[AUR]` — package comes from the AUR (requires `paru`)

---

## Base system & kernel

- `base` — Arch base system
- `base-devel` — core build tooling (required for AUR builds and any compilation)
- `linux` — Linux kernel
- `linux-firmware` — firmware blobs for hardware (Wi-Fi, GPU, etc.)
- `linux-headers` — kernel headers (needed for DKMS modules such as kanata)
- `amd-ucode` — AMD CPU microcode (swap for `intel-ucode` on Intel)
- `mesa` — open-source OpenGL/Vulkan stack
- `vulkan-radeon` — Vulkan driver for AMD GPUs
- `sof-firmware` — Sound Open Firmware for modern audio chipsets

## Boot, disks, encryption

- `grub` — bootloader
- `grub-btrfs` — auto-generates grub entries for btrfs snapshots
- `efibootmgr` — manages EFI boot entries
- `os-prober` — discovers other OSes for the grub menu
- `btrfs-progs` — btrfs userspace utilities
- `snapper` — btrfs snapshot manager
- `dosfstools` — FAT utilities (required for the EFI partition)
- `exfatprogs` — exFAT support
- `ntfs-3g` — NTFS support (for external Windows drives)
- `smartmontools` — S.M.A.R.T. monitoring for SSDs/HDDs
- `fwupd` — firmware updates

## Networking

- `networkmanager` — network management
- `iwd` — modern Wi-Fi backend (drop-in for wpa_supplicant)
- `dnsmasq` — local caching DNS resolver, spawned by NetworkManager (`dns=dnsmasq` backend) and also used by libvirt
- `iptables` — netfilter (firewall foundation)
- `ufw` — simple firewall on top of iptables
- `mkcert` — generate locally-trusted self-signed certificates for development
- `arch-audit` — checks installed packages for known CVEs

### TUI / network diagnostics

- `impala` — Wi-Fi TUI
- `bluetui` — Bluetooth TUI
- `bluez-utils` — Bluetooth utilities
- `bandwhich` — per-process network bandwidth monitor
- `gping` — ping with a live graph
- `doggo` — modern `dig`
- `mtr` — combined ping + traceroute
- `whois`
- `nmap` — port scanner
- `gobuster` — directory and DNS bruteforcer
- `ffuf` `[AUR]` — web fuzzer
- `tcpdump` — packet sniffer
- `termshark` — TUI wrapper around wireshark

### Proxy / VPN

- `xray` — proxy platform with XTLS support

## Hyprland & Wayland environment

- `hyprland` — Wayland compositor
- `hypridle` — idle/lock management
- `hyprpaper` — wallpaper
- `hyprpicker` — color picker
- `hyprcursor` — vector-aware cursor format
- `hyprpolkitagent` — polkit agent for Hyprland
- `xdg-desktop-portal-hyprland` — XDG portal for Hyprland (screenshots, screen sharing)
- `xdg-desktop-portal-gtk` — XDG portal for GTK apps
- `noctalia-shell` `[AUR]` — primary desktop shell (bar, panel, OSD)
- `noctalia-qs` `[AUR]` — quickshell fork that powers Noctalia
- `wlsunset` — blue-light filter for Wayland
- `cliphist` — clipboard manager for Wayland
- `ly` — TUI display manager
- `phinger-cursors` `[AUR]` — cursor theme
- `adw-gtk-theme` — libadwaita-style theme for GTK3 apps
- `matugen` — Material You palette generator (drives Noctalia and custom templates)
- `ttf-jetbrains-mono-nerd` — primary monospace Nerd Font
- `noto-fonts` — Noto fonts (broad Unicode coverage)
- `noto-fonts-emoji` — emoji font

## Terminal, shell, prompt

- `foot` — main Wayland terminal (used by the floating-terminal setup)
- `fish` — primary shell
- `starship` — cross-shell prompt
- `tmux` — terminal multiplexer

## CLI utilities (modern replacements)

- `bat` — `cat` with syntax highlighting
- `eza` — `ls` with colors and icons
- `fd` — fast `find` replacement
- `ripgrep` — fast `grep` replacement
- `sd` — simple `sed` replacement
- `zoxide` — smart `cd` with history
- `fzf` — fuzzy finder
- `less` — pager
- `tree` — directory tree
- `tldr` — short man pages with examples
- `wget`
- `rsync` — file sync
- `inotify-tools` — filesystem change watcher
- `7zip`
- `zip`
- `unzip`
- `pacman-contrib` — `paccache`, `checkupdates`, etc.

## System monitoring & logs

- `btop` — primary resource monitor
- `radeontop` — AMD GPU usage
- `duf` — pretty `df`
- `dust` — pretty `du`
- `strace` — syscall tracer
- `lazyjournal` `[AUR]` — TUI for journalctl and container logs
- `jolt` — TUI battery / power monitor
- `upower` — DBus power-management daemon

## Performance & power

- `auto-cpufreq` `[AUR]` — automatic CPU frequency tuning (battery)
- `earlyoom` — kills runaway processes before the system thrashes
- `zram-generator` — compressed swap in RAM

## Files

- `yazi` — primary TUI file manager
- `nautilus` — GUI file manager (when drag-and-drop matters)
- `file-roller` — GUI archive manager (used by nautilus)
- `gvfs-mtp` — MTP support for gvfs (Android in nautilus)
- `gvfs-gphoto2` — gphoto2 (cameras)
- `gvfs-nfs` — NFS shares
- `gvfs-smb` — SMB shares
- `android-file-transfer` — fallback when gvfs-mtp misbehaves

## Editors & IDEs

- `neovim` — primary editor
- `zed` — GUI editor for larger projects

## Development

- `git`
- `github-cli` — `gh`
- `lazygit` — TUI for git
- `claude-code` `[AUR]` — Claude Code CLI
- `nodejs`, `npm`
- `bun` — JS runtime/bundler
- `go`
- `rustup` — Rust toolchain manager
- `clang`
- `cmake`
- `mise` — runtime version manager (node, python, etc.)
- `buf` — Protocol Buffers tooling

## Containers & virtualization

- `docker`
- `docker-compose`
- `lazydocker` — TUI for docker
- `libvirt`
- `qemu-desktop` — QEMU
- `virt-manager` — GUI for libvirt

## Browsers & internet

- `helium-browser-bin` `[AUR]` — primary browser (Chromium-based, privacy-focused)
- `zen-browser-bin` `[AUR]` — Firefox-based browser
- `chromium` — fallback for testing and compatibility
- `thunderbird` — email client

## API & web tooling

- `httpie` — `curl` for humans
- `bruno-bin` `[AUR]` — open-source Postman alternative

## Office & notes

- `libreoffice-fresh` — office suite
- `obsidian` — notes
- `evince` — PDF viewer
- `loupe` — image viewer
- `gnome-calculator` — calculator
- `dialect` — translation app (GUI)
- `translate-shell` — translation (CLI)

## Printing & scanning

- `cups` — print server (provides the `cups.socket` activation unit)
- `cups-pdf` — virtual PDF printer (prints to `~/Desktop/`)
- `system-config-printer` — GUI for adding and managing printers
- `gutenprint` — driver collection covering most modern inkjet/laser printers
- `avahi` — mDNS/DNS-SD daemon (lets `cups` auto-discover IPP printers on the LAN)
- `nss-mdns` — NSS module that resolves `*.local` hostnames via avahi
- `sane` — scanner backend
- `simple-scan` — minimal GUI scanner front-end

> Brand-specific drivers (`hplip` for HP, `epson-inkjet-printer-escpr` for Epson, `brlaser` for Brother) are intentionally **not** in the default list — they're large and only needed for older non-IPP printers. Install ad-hoc if your hardware needs them.

## Audio

- `pipewire` — sound server
- `pipewire-alsa` — ALSA layer for PipeWire
- `pipewire-audio`
- `pipewire-jack` — JACK compatibility
- `pipewire-pulse` — PulseAudio compatibility
- `wireplumber` — PipeWire session manager
- `easyeffects` — audio effects, equalizer
- `lsp-plugins-ladspa`, `lsp-plugins-lv2` — DSP plugins (used by easyeffects)
- `wiremix` — TUI mixer
- `amberol` — simple GUI music player
- `cliamp` `[AUR]` — Winamp-style TUI player
- `cuetools` — CUE sheet utilities

## Video & media

- `mpv` — primary video player
- `mpv-uosc` `[AUR]` — UI for mpv
- `mpv-thumbfast-git` `[AUR]` — on-the-fly thumbnails for mpv
- `obs-studio` — recording and streaming
- `yt-dlp` — video downloader (YouTube and many more)
- `chafa` — image/video rendering in the terminal (used by yazi)

## Screenshots & OCR

- `satty` — primary screenshot annotator
- `swappy` — older annotator (kept as fallback)
- `tesseract` — OCR engine
- `tesseract-data-eng` — English data for tesseract
- `tesseract-data-rus` — Russian data for tesseract
- `snapshot` — GNOME camera (webcam stills/clips)

## Downloading & sharing

- `qbittorrent` — torrent client
- `syncthing` — peer-to-peer sync between devices
- `localsend-bin` `[AUR]` — AirDrop alternative over LAN
- `surge` `[AUR]` — TUI download manager written in Go

## Dev / data utilities

- `perl-image-exiftool` — file metadata
- `python-pillow` — image library (for scripts)
- `python-pyacoustid` — audio fingerprinting
- `python-pylast` — Last.fm API

## Databases

- `dbgate-bin` `[AUR]` — cross-platform GUI database client (PostgreSQL, MySQL, SQL Server, SQLite, MongoDB, etc.)

## Keyboard

- `kanata-bin` `[AUR]` — kernel-level key remapping (uses uinput)

## Diagnostics / misc

- `ttl-bin` `[AUR]` — TUI traceroute
- `reflector` — refresh pacman mirrors
- `stow` — symlink manager for dotfiles
