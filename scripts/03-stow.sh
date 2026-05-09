#!/usr/bin/env bash
# Symlinks dotfiles into $HOME via stow.
# Idempotent: --restow tears down old links and recreates them.

source "$(dirname "$(readlink -f "$0")")/lib.sh"

require_not_root
command -v stow &>/dev/null || die "stow is not installed. Install it: paru -S stow"

# Every top-level directory is treated as a stow package, except those listed below.
EXCLUDE=(scripts .git)

cd "$DOTFILES_DIR"

PACKAGES=()
for entry in */; do
  name="${entry%/}"
  skip=0
  for ex in "${EXCLUDE[@]}"; do
    [[ "$name" == "$ex" ]] && skip=1 && break
  done
  [[ $skip -eq 1 ]] && continue
  PACKAGES+=("$name")
done

log "Stow packages (${#PACKAGES[@]}): ${PACKAGES[*]}"
log "Target: $HOME"

# --adopt would be dangerous (it absorbs existing files). Use --restow instead.
# If a conflicting file already lives in $HOME, stow will report it and exit.
if ! stow --target="$HOME" --restow --verbose=1 "${PACKAGES[@]}" 2>&1; then
  warn "stow failed — likely a conflict with an existing file in \$HOME."
  warn "Remove or back up the conflicting file and rerun this script."
  exit 1
fi

ok "Configs stowed."
