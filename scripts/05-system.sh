#!/usr/bin/env bash
# System-level tweaks: groups, udev for kanata, zram, NetworkManager+iwd.
# Every step is idempotent and safe to rerun.

source "$(dirname "$(readlink -f "$0")")/lib.sh"

require_not_root
ensure_sudo

# 1. User groups -------------------------------------------------------------
log "Configuring user groups..."

# kanata needs the uinput group; create it if missing.
if ! getent group uinput &>/dev/null; then
  sudo groupadd -r uinput
  ok "uinput group created"
fi

GROUPS_TO_ADD=(docker input uinput libvirt lp scanner)
for g in "${GROUPS_TO_ADD[@]}"; do
  if ! getent group "$g" &>/dev/null; then
    warn "group $g does not exist, skipping (related package not installed?)"
    continue
  fi
  if id -nG "$USER" | tr ' ' '\n' | grep -qx "$g"; then
    ok "$USER is already in group $g"
  else
    sudo usermod -aG "$g" "$USER"
    ok "$USER added to group $g (relogin required)"
  fi
done

# 2. udev rules for kanata ---------------------------------------------------
log "Configuring udev for kanata (uinput)..."
UDEV_RULE=/etc/udev/rules.d/99-uinput.rules
if [[ ! -f $UDEV_RULE ]]; then
  echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' \
    | sudo tee "$UDEV_RULE" >/dev/null
  sudo udevadm control --reload-rules
  sudo udevadm trigger
  ok "udev rule created"
else
  ok "udev rule already in place"
fi

# Load the uinput module on boot.
if [[ ! -f /etc/modules-load.d/uinput.conf ]]; then
  echo "uinput" | sudo tee /etc/modules-load.d/uinput.conf >/dev/null
  ok "uinput added to modules-load.d"
fi
sudo modprobe uinput 2>/dev/null || true

# 3. zram swap ---------------------------------------------------------------
log "Configuring zram..."
ZRAM_CONF=/etc/systemd/zram-generator.conf
if [[ ! -f $ZRAM_CONF ]]; then
  sudo tee "$ZRAM_CONF" >/dev/null <<'EOF'
[zram0]
zram-size = min(ram / 2, 4096)
compression-algorithm = zstd
EOF
  sudo systemctl daemon-reload
  ok "zram-generator configured"
else
  ok "zram-generator already configured"
fi

# 4. NetworkManager: iwd Wi-Fi backend + dnsmasq DNS backend -----------------
log "Configuring NetworkManager (iwd + dnsmasq)..."
NM_CONF_DIR=/etc/NetworkManager/conf.d
NM_IWD_CONF="$NM_CONF_DIR/wifi_backend.conf"
NM_DNS_CONF="$NM_CONF_DIR/dns.conf"
sudo mkdir -p "$NM_CONF_DIR"

if [[ ! -f $NM_IWD_CONF ]]; then
  sudo tee "$NM_IWD_CONF" >/dev/null <<'EOF'
[device]
wifi.backend=iwd
EOF
  ok "NetworkManager set to iwd Wi-Fi backend"
else
  ok "iwd backend already configured"
fi

if [[ ! -f $NM_DNS_CONF ]]; then
  sudo tee "$NM_DNS_CONF" >/dev/null <<'EOF'
[main]
dns=dnsmasq
EOF
  ok "NetworkManager set to dnsmasq DNS backend (local caching resolver)"
else
  ok "dnsmasq DNS backend already configured"
fi

# 5. /tmp cleanup on boot (needed when /tmp is its own btrfs subvolume) ------
log "Configuring tmpfiles for /tmp..."
TMP_CONF=/etc/tmpfiles.d/tmp.conf
if [[ ! -f $TMP_CONF ]]; then
  sudo tee "$TMP_CONF" >/dev/null <<'EOF'
# Clean /tmp on every boot (required when /tmp is a separate subvolume).
D! /tmp 1777 root root 0
EOF
  ok "tmpfiles for /tmp configured"
else
  ok "tmpfiles already in place"
fi

ok "System tweaks applied."
warn "Group changes require a relogin (or reboot)."
warn "A reboot is recommended to apply zram and iwd."
