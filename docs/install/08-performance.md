# Stage 8 — Performance

[← Snapshots](07-snapshots.md) · [Index](README.md) · [Next: Development →](09-development.md)

> Compressed RAM swap, an OOM guard against freezes, and CPU frequency management for battery life.

> Most of these packages come from `scripts/pacman.txt`, and `scripts/05-system.sh` already writes the zram config. This stage documents each piece and how to enable it manually.

---

## 1. zram (compressed RAM swap)

```bash
sudo tee /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF

sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service
```

## 2. earlyoom (prevents hard freezes)

Kills a memory hog before the system locks up under pressure.

```bash
sudo systemctl enable --now earlyoom
```

## 3. auto-cpufreq (battery life)

```bash
sudo systemctl enable --now auto-cpufreq
```

## 4. Check boot performance

```bash
systemd-analyze          # total boot time
systemd-analyze blame    # what took the longest
```

---

**Next:** [Stage 9 — Development →](09-development.md)
