#!/usr/bin/env bash
# Main entrypoint. Runs every step in order.
#
# Usage:
#   ./scripts/install.sh                     # run every step
#   ./scripts/install.sh paru                # run a single step
#   ./scripts/install.sh packages stow services
#
# Available steps: paru | packages | stow | services | system

source "$(dirname "$(readlink -f "$0")")/lib.sh"

require_not_root
require_arch

declare -A STEPS=(
  [paru]="01-paru.sh"
  [packages]="02-packages.sh"
  [stow]="03-stow.sh"
  [services]="04-services.sh"
  [system]="05-system.sh"
)

ORDER=(paru packages stow services system)

run_step() {
  local name="$1"
  local script="${STEPS[$name]:-}"
  [[ -z "$script" ]] && die "Unknown step: $name"
  echo
  log "=== Step: $name ($script) ==="
  bash "$SCRIPTS_DIR/$script"
}

if [[ $# -eq 0 ]]; then
  TO_RUN=("${ORDER[@]}")
else
  TO_RUN=("$@")
fi

for step in "${TO_RUN[@]}"; do
  run_step "$step"
done

echo
ok "Done. Reboot to apply zram, group changes, and the iwd backend."
