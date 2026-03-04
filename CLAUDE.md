# james-dotfiles — Project Instructions

## What this repo is
Dotfiles repo for syncing shell config, Claude Code settings, Cursor settings, and job profiles across machines.

## Structure
- `shell/` — .zshrc, aliases, functions
- `claude-code/` — Claude Code settings.json and global CLAUDE.md
- `cursor/` — Cursor editor settings
- `jobs/{crunchyroll,mcd,orka,personal}/` — per-job .gitconfig and claude.json overrides
- `scripts/` — install.sh (one-time setup), sync.sh (pull/push helper)

## Rules for editing this repo
- Keep all config files in their proper subdirectories
- install.sh COPIES claude-code/settings.json (not symlink) so job() can overwrite safely
- install.sh SYMLINKS CLAUDE.md since it doesn't change per-job
- Test changes with `zsh -n shell/aliases.zsh && zsh -n shell/functions.zsh`
- Placeholders use `TODO:` prefix — user fills in real values before pushing
