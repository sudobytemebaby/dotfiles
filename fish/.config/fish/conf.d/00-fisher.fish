# Fisher plugin manager bootstrap.
# Plugins are tracked in ~/.config/fish/fish_plugins. To install or sync:
#   fisher update

set -g fisher_path $HOME/.local/share/fisher

# Make installed plugins discoverable to fish's autoloader.
set -gp fish_function_path $fisher_path/functions
set -gp fish_complete_path $fisher_path/completions

# Auto-install on first interactive run.
if status is-interactive
    and not test -f $fisher_path/functions/fisher.fish
    echo "Installing Fisher…"
    mkdir -p $fisher_path/functions
    and curl -fsSL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
        -o $fisher_path/functions/fisher.fish
    and fish -c "fisher update"
end
