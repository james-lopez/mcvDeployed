# dotfiles — Project Instructions

## What this repo is
Dotfiles repo for syncing shell config and terminal settings across machines.

## Structure
- `shell/` — .zshrc, .zpreztorc, aliases, functions
- `ghostty/` — Ghostty terminal config
- `scripts/` — install.sh (one-time setup)

## Rules for editing this repo
- Keep all config files in their proper subdirectories
- Test changes with `zsh -n shell/aliases.zsh && zsh -n shell/functions.zsh`
