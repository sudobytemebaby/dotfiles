# Bun
set -gx BUN_INSTALL $HOME/.bun

# Editor preferences
set -gx EDITOR nvim
set -gx VISUAL nvim

# Set variable for virtualization
set -gx LIBVIRT_DEFAULT_URI qemu:///system

# Starship custom config path
set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
