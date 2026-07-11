# Stage 7 — Snapshots

[← Dotfiles & scripts](06-dotfiles-and-scripts.md) · [Index](README.md) · [Next: Performance →](08-performance.md)

> Wire up the snapshot stack so every change is captured and every snapshot is bootable: **snapper** (the manager), **snap-pac** (auto pre/post snapshots around pacman), and **grub-btrfs** (snapshots in the boot menu).

Because `/boot` lives on btrfs (Stage 2), snapshots contain their own kernel and boot cleanly from the GRUB menu. `snapper` and `snap-pac` were installed with the base system in [Stage 3](03-base-system.md).

---

## 1. Verify your subvolumes

```bash
btrfs subvolume list /
```

You should see `@`, `@home`, `@log`, `@pkg`, `@tmp`, and `@snapshots`.

## 2. Create the snapper config

`.snapshots` already exists (we created `@snapshots` and mount it there), which trips up `create-config`. This dance works around it:

```bash
# 1. Unmount and remove the existing .snapshots.
sudo umount /.snapshots
sudo rmdir /.snapshots

# 2. Create the config (works now that .snapshots is gone).
sudo snapper -c root create-config /

# 3. Delete the subvolume snapper just made — we want our own @snapshots.
sudo btrfs subvolume delete /.snapshots

# 4. Recreate the mount point and mount our @snapshots.
sudo mkdir /.snapshots
sudo mount /.snapshots

# 5. Let your wheel-group user manage snapshots without sudo.
sudo snapper -c root set-config "ALLOW_GROUPS=wheel"
sudo snapper -c root set-config "SYNC_ACL=yes"
sudo chown :wheel /.snapshots
sudo chmod 750 /.snapshots

# 6. Verify.
snapper -c root list
```

## 3. Tune snapper settings

```bash
sudo vim /etc/snapper/configs/root
```

The mental model: **`snap-pac` is your primary safety net** — it snapshots every pacman transaction — so the *timeline* only needs to be a light net for non-package changes (edited configs, accidental deletes). Set:

```bash
# --- Timeline: light net for non-package changes ---
TIMELINE_CREATE="yes"
TIMELINE_CLEANUP="yes"
TIMELINE_MIN_AGE="1800"          # snapshots at most every 30 min
TIMELINE_LIMIT_HOURLY="5"        # last 5 hours
TIMELINE_LIMIT_DAILY="7"         # last 7 days
TIMELINE_LIMIT_WEEKLY="1"        # one weekly anchor past the daily window
TIMELINE_LIMIT_MONTHLY="0"       # no long-term system history
TIMELINE_LIMIT_QUARTERLY="0"
TIMELINE_LIMIT_YEARLY="0"

# --- snap-pac (pacman) pre/post pairs: the main safety net ---
NUMBER_CLEANUP="yes"
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="20"                # ~10 recent pacman transactions (pre + post)
NUMBER_LIMIT_IMPORTANT="10"

# --- Prune pre/post pairs where nothing actually changed ---
EMPTY_PRE_POST_CLEANUP="yes"
EMPTY_PRE_POST_MIN_AGE="1800"

# --- Performance ---
BACKGROUND_COMPARISON="yes"
SYNC_ACL="yes"
```

> Timeline snapshots are created **hourly** by `snapper-timeline.timer` regardless of these numbers — the `LIMIT_*` values only control how many are *kept*. The above retains roughly 5 + 7 + 1 ≈ 13 timeline snapshots plus your snap-pac pairs.

`snap-pac` itself needs no config — it's a pacman hook. From your next transaction on, it creates a pre + post pair automatically, and because `/boot` is on btrfs those pairs are bootable. (Quirk: the very first transaction after the config exists may leave only a lone post-snapshot — that's normal.)

## 4. Configure grub-btrfs

```bash
sudo vim /etc/default/grub-btrfs/config
```

Set:

```bash
GRUB_BTRFS_SUBMENUNAME="Arch Snapshots"
GRUB_BTRFS_LIMIT="30"
```

## 5. Enable the services

```bash
# Automatic timeline snapshots + cleanup.
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# Regenerate the snapshot boot menu when snapshots change.
sudo systemctl enable --now grub-btrfsd.service

# Your first snapshot.
sudo snapper -c root create --description "Fresh Installation"
snapper -c root list
```

> If you ran `scripts/install.sh` (Stage 6), `04-services.sh` already enabled the two snapper timers and `grub-btrfsd` — this step just confirms them and creates the first snapshot.

---

**Next:** [Stage 8 — Performance →](08-performance.md)
