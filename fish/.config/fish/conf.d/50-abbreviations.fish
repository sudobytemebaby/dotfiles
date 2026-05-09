# Abbreviations expand inline before execution, so the real command is
# what ends up in history and on screen. Prefer them over aliases for
# anything that doesn't need argument handling.

status is-interactive
or return

# --- Editor -----------------------------------------------------------
abbr -a v   nvim
abbr -a vi  nvim
abbr -a vim nvim

# --- Shell ------------------------------------------------------------
abbr -a c      clear
abbr -a e      exit
abbr -a q      exit
abbr -a reload 'exec fish'
abbr -a fishrc '$EDITOR ~/.config/fish/config.fish'

# --- Navigation -------------------------------------------------------
abbr -a -- -  'cd -'
abbr -a ..    'cd ..'
abbr -a ...   'cd ../..'
abbr -a ....  'cd ../../..'

# --- Listing (eza) ----------------------------------------------------
# Bare `ls` is overridden by functions/ls.fish; these cover common modes.
abbr -a l  ls
abbr -a ll 'eza -l  --icons --git --color=auto'
abbr -a la 'eza -la --icons --git --color=auto'
abbr -a lt 'eza --tree --icons --git --color=auto --level=2'

# --- Git --------------------------------------------------------------
abbr -a g    git
abbr -a gs   'git status'
abbr -a gss  'git status -s'
abbr -a ga   'git add'
abbr -a gaa  'git add --all'
abbr -a gc   'git commit'
abbr -a gcm  'git commit -m'
abbr -a gca  'git commit --amend'
abbr -a gco  'git checkout'
abbr -a gb   'git branch'
abbr -a gd   'git diff'
abbr -a gds  'git diff --staged'
abbr -a gl   'git log --oneline --graph --decorate'
abbr -a gla  'git log --oneline --graph --decorate --all'
abbr -a gp   'git push'
abbr -a gpl  'git pull'
abbr -a gst  'git stash'
abbr -a gsp  'git stash pop'

# --- Arch (pacman + paru) --------------------------------------------
abbr -a pi  'sudo pacman -S'
abbr -a pr  'sudo pacman -Rns'
abbr -a pu  'sudo pacman -Syu'
abbr -a pss 'pacman -Ss'
abbr -a pq  'pacman -Q'
abbr -a pqs 'pacman -Qs'
abbr -a yi  'paru -S'
abbr -a yu  'paru -Syu'

# --- systemd ----------------------------------------------------------
abbr -a sc  systemctl
abbr -a scu 'systemctl --user'
abbr -a jc  journalctl
abbr -a jcu 'journalctl --user'
