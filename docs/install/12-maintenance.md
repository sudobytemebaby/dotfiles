# Stage 12 — Maintenance

[← Security](11-security.md) · [Index](README.md)

> A few timers and habits to keep the system tidy over time. This is the last stage.

---

## 1. Maintenance tools

```bash
# pacman-contrib and tldr already ship in scripts/pacman.txt.
sudo pacman -S --needed pkgfile man-db man-pages
```

## 2. Pacman cache cleaning

```bash
du -sh /var/cache/pacman/pkg/       # current size
sudo paccache -r                    # keep last 3 versions of each package
sudo paccache -ruk0                 # drop cache for uninstalled packages

# Automate (already enabled by scripts/04-services.sh).
sudo systemctl enable --now paccache.timer
```

## 3. Journal log rotation

```bash
journalctl --disk-usage
sudoedit /etc/systemd/journald.conf
```

```ini
[Journal]
SystemMaxUse=500M
SystemMaxFileSize=50M
MaxRetentionSec=2weeks
```

```bash
sudo systemctl restart systemd-journald
# One-off trim: sudo journalctl --vacuum-size=500M
```

## 4. Orphan cleanup

```bash
pacman -Qtdq                                          # list orphans (empty = none)
pacman -Qtdq | sudo pacman -Rns - 2>/dev/null || echo "no orphans"
```

## 5. Mirrors

```bash
systemctl list-timers reflector.timer                 # confirms the timer from Stage 5
sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```

## 6. Cadence

- **Daily** — snapper snapshots (automatic), `arch-audit` for CVEs
- **Weekly** — `paccache.timer`, journal rotation, orphan removal
- **Monthly** — mirror refresh (`reflector.timer` handles it)

---

## Done 🎉

You now have a fully encrypted Arch system with **bootable btrfs snapshots**, the userland from `scripts/install.sh`, and the annotated inventory in [PACKAGES.md](../../PACKAGES.md).

Habits worth keeping:

- `snap-pac` snapshots every upgrade automatically — no need to snapshot manually before `pacman -Syu`. Still take a named one before anything genuinely risky outside pacman: `snapper -c root create -d "before X"`.
- Rerun `./scripts/install.sh` after editing `scripts/pacman.txt` / `scripts/aur.txt` to keep the system in sync.
- Boot into a recent snapshot from the GRUB menu now and then to confirm recovery works (only snapshots taken under the `/boot`-on-btrfs layout are bootable).

[↑ Back to the installation index](README.md)
