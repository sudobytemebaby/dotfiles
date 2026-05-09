#!/usr/bin/env bash
# Installs paru (AUR helper) if it is not already installed.

source "$(dirname "$(readlink -f "$0")")/lib.sh"

require_not_root
require_arch

if command -v paru &>/dev/null; then
  ok "paru is already installed ($(paru --version | head -n1))"
  exit 0
fi

log "Installing paru-bin from AUR..."
ensure_sudo

sudo pacman -S --needed --noconfirm git base-devel

build_dir=$(mktemp -d)
trap 'rm -rf "$build_dir"' EXIT

git clone --depth=1 https://aur.archlinux.org/paru-bin.git "$build_dir/paru-bin"
( cd "$build_dir/paru-bin" && makepkg -si --noconfirm )

ok "paru installed: $(paru --version | head -n1)"
