#!/usr/bin/env bash
# Enables systemd services (system + user). Idempotent.

source "$(dirname "$(readlink -f "$0")")/lib.sh"

require_not_root
ensure_sudo

# System-level services (require sudo).
SYSTEM_SERVICES=(
  NetworkManager.service              # network management
  ly.service                          # display manager
  bluetooth.service                   # bluetooth
  docker.service                      # docker daemon
  earlyoom.service                    # OOM killer
  auto-cpufreq.service                # CPU governor
  cups.socket                         # printing (socket-activated, only runs on demand)
  avahi-daemon.service                # mDNS/DNS-SD (printer auto-discovery)
  reflector.timer                     # pacman mirror refresh
  paccache.timer                      # weekly pacman cache cleanup
  snapper-timeline.timer              # automatic snapshots
  snapper-cleanup.timer               # snapshot cleanup
  grub-btrfsd.service                 # rebuild grub when snapshots appear
  systemd-zram-setup@zram0.service    # zram swap
)

# User-level services (no sudo). Started inside the user's session.
USER_SERVICES=(
  kanata.service                      # keyboard remapping
)

enable_unit() {
  local unit="$1" scope="$2"
  if [[ "$scope" == "system" ]]; then
    if systemctl list-unit-files "$unit" &>/dev/null && \
       sudo systemctl cat "$unit" &>/dev/null; then
      sudo systemctl enable --now "$unit" 2>&1 | sed "s/^/  /"
      ok "[system] $unit"
    else
      warn "[system] $unit — unit file not found, skipping"
    fi
  else
    if systemctl --user list-unit-files "$unit" &>/dev/null && \
       systemctl --user cat "$unit" &>/dev/null; then
      systemctl --user enable --now "$unit" 2>&1 | sed "s/^/  /"
      ok "[user] $unit"
    else
      warn "[user] $unit — unit file not found, skipping"
    fi
  fi
}

log "Enabling system services..."
for svc in "${SYSTEM_SERVICES[@]}"; do
  enable_unit "$svc" system
done

log "Enabling user services..."
for svc in "${USER_SERVICES[@]}"; do
  enable_unit "$svc" user
done

# xray is enabled separately — only if a config exists.
if [[ -f "$HOME/.config/xray/xsn.json" ]]; then
  enable_unit xray.service user
else
  warn "xray.service skipped: $HOME/.config/xray/xsn.json is missing"
fi

ok "Services configured."
