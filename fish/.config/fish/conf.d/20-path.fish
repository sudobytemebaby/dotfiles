# PATH additions.
# `fish_add_path` is idempotent and silent on missing directories,
# so unconditional listing is safe and clearer than guarded blocks.

fish_add_path \
    $HOME/.local/bin \
    $HOME/.cargo/bin \
    $HOME/go/bin \
    $HOME/.bun/bin
