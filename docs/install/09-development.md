# Stage 9 — Development

[← Performance](08-performance.md) · [Index](README.md) · [Next: Desktop & services →](10-desktop-and-services.md)

> SSH key, git identity, and the manual dotfiles fallback.

---

## 1. SSH key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Public key to add at https://github.com/settings/keys
cat ~/.ssh/id_ed25519.pub
```

## 2. Git identity

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
git config --global color.ui auto
git config --global init.defaultBranch main
```

## 3. Dotfiles (manual fallback)

> Already handled by `scripts/03-stow.sh` if you ran the automated setup ([Stage 6](06-dotfiles-and-scripts.md)). Use this only if you skipped it.

```bash
cd ~
git clone git@github.com:sudobytemebaby/dotfiles.git
cd dotfiles

# Symlink every config directory into $HOME (skipping scripts/).
stow --target="$HOME" $(ls -d */ | grep -v '^scripts/$' | tr -d /)
```

---

**Next:** [Stage 10 — Desktop & services →](10-desktop-and-services.md)
