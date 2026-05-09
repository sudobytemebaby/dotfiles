# Environment variables exported to all child processes.
# Sourced for both interactive and non-interactive shells.

# --- XDG base directories (set explicitly so apps respect them) ---
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_HOME   $HOME/.local/share
set -gx XDG_STATE_HOME  $HOME/.local/state
set -gx XDG_CACHE_HOME  $HOME/.cache

# --- Editor / pager ---
set -gx EDITOR    nvim
set -gx VISUAL    $EDITOR
set -gx PAGER     less
set -gx MANPAGER  'nvim +Man!'

# Less: quit-if-one-screen, raw colors, no-clear, mouse, color, smart-case search.
set -gx LESS         '-FRX -i --mouse --use-color'
set -gx LESSHISTFILE -

# --- Tooling ---
set -gx BUN_INSTALL        $HOME/.bun
set -gx STARSHIP_CONFIG    $XDG_CONFIG_HOME/starship/starship.toml
set -gx LIBVIRT_DEFAULT_URI qemu:///system

# --- fzf defaults (used when invoking fzf directly; fzf.fish has its own) ---
if type -q fzf
    set -gx FZF_DEFAULT_OPTS '--height=40% --layout=reverse --border --info=inline'
    if type -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        set -gx FZF_CTRL_T_COMMAND  $FZF_DEFAULT_COMMAND
    end
end
