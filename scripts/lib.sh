#!/usr/bin/env bash
# Shared helpers for install scripts. Source this file, don't run it.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"

C_RESET=$'\033[0m'
C_BLUE=$'\033[1;34m'
C_GREEN=$'\033[1;32m'
C_YELLOW=$'\033[1;33m'
C_RED=$'\033[1;31m'

log()  { printf '%s==>%s %s\n' "$C_BLUE"   "$C_RESET" "$*"; }
ok()   { printf '%s[OK]%s %s\n'  "$C_GREEN"  "$C_RESET" "$*"; }
warn() { printf '%s[!]%s %s\n'  "$C_YELLOW" "$C_RESET" "$*"; }
die()  { printf '%s[X]%s %s\n'  "$C_RED"    "$C_RESET" "$*" >&2; exit 1; }

require_not_root() {
  [[ $EUID -ne 0 ]] || die "Do not run as root. sudo is invoked from inside the script."
}

require_arch() {
  command -v pacman >/dev/null || die "pacman not found. This script only works on Arch."
}

ensure_sudo() {
  log "Asking for sudo (will be kept alive in the background)..."
  sudo -v || die "Failed to obtain sudo."
  ( while true; do sudo -n true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) 2>/dev/null &
}
