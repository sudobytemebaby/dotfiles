#!/usr/bin/env bash
# Installs every package from pacman.txt and aur.txt via paru.

source "$(dirname "$(readlink -f "$0")")/lib.sh"

require_not_root
require_arch

command -v paru &>/dev/null || die "paru not installed. Run scripts/01-paru.sh first."

ensure_sudo

read_packages() {
  # Read a file, ignoring blank lines and comments.
  grep -vE '^\s*(#|$)' "$1" || true
}

mapfile -t PACMAN_PKGS < <(read_packages "$SCRIPTS_DIR/pacman.txt")
mapfile -t AUR_PKGS    < <(read_packages "$SCRIPTS_DIR/aur.txt")

log "Official packages: ${#PACMAN_PKGS[@]}"
log "AUR packages: ${#AUR_PKGS[@]}"

if [[ ${#PACMAN_PKGS[@]} -gt 0 ]]; then
  log "Installing official packages via paru (--repo skips AUR lookup)..."
  paru -S --needed --noconfirm --repo "${PACMAN_PKGS[@]}"
fi

if [[ ${#AUR_PKGS[@]} -gt 0 ]]; then
  log "Installing AUR packages (--skipreview, fully unattended)..."
  paru -S --needed --noconfirm --skipreview "${AUR_PKGS[@]}"
fi

ok "All packages installed."
