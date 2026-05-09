# Interactive shell integrations. Each block is guarded so the config
# stays portable across machines that may not have every tool installed.

status is-interactive
or return

# Starship prompt.
type -q starship
and starship init fish | source

# Zoxide: replaces `cd` with smart directory jumping.
type -q zoxide
and zoxide init fish --cmd cd | source

# fzf.fish keybindings (provided by patrickf1/fzf.fish).
type -q fzf_configure_bindings
and fzf_configure_bindings \
    --directory=\cf \
    --git_status=\cs \
    --processes=\cp
