# Stage 11 — Security

[← Desktop & services](10-desktop-and-services.md) · [Index](README.md) · [Next: Maintenance →](12-maintenance.md)

> Your disk is already encrypted. These add a firewall and — if you run sshd — SSH hardening and fail2ban.

> `ufw` and `arch-audit` ship in `scripts/pacman.txt`. `fail2ban` and `openssh` do **not** — install them only if you need them.

---

## 1. Install security essentials

```bash
sudo pacman -S --needed ufw arch-audit
# sudo pacman -S --needed fail2ban openssh   # only if you run sshd
```

## 2. Firewall (UFW)

```bash
sudo systemctl enable --now ufw

sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH only if you use it (don't lock yourself out on a remote box).
sudo ufw allow ssh
# sudo ufw allow 80/tcp      # HTTP
# sudo ufw allow 443/tcp     # HTTPS

sudo ufw enable
sudo ufw status verbose
```

Inspecting: `sudo ufw status numbered`, delete with `sudo ufw delete [number]`, disable temporarily with `sudo ufw disable`.

## 3. Harden SSH

Only relevant if you actually run `sshd`.

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
sudoedit /etc/ssh/sshd_config
```

Key settings:

```bash
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
PermitEmptyPasswords no
MaxAuthTries 3
LoginGraceTime 30
X11Forwarding no
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
# Port 2222              # optional
# AllowUsers yourusername # optional
```

Apply:

```bash
sudo sshd -t                     # validate first
sudo systemctl restart sshd
```

**Before closing your session**, open a second SSH connection and confirm it works.

## 4. fail2ban

Bans IPs after repeated auth failures.

```bash
# Local override (jail.conf gets overwritten on update).
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudoedit /etc/fail2ban/jail.local
```

```ini
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5

[sshd]
enabled = true
port = ssh
```

```bash
sudo systemctl enable --now fail2ban
sudo fail2ban-client status sshd
# Unban: sudo fail2ban-client set sshd unbanip [IP]
```

---

**Next:** [Stage 12 — Maintenance →](12-maintenance.md)
