# dotfiles

Portable shell and terminal config. Clone, install, go.

## What this does

- **Shell config** — Prezto + Pure prompt, aliases, functions
- **Terminal config** — Ghostty settings synced via symlink

## Setup

```bash
git clone git@github.com:james-lopez/mcvDeployed.git
cd mcvDeployed
chmod +x scripts/install.sh
./scripts/install.sh
```

The installer will:
- Remove Oh My Zsh / Powerlevel10k if present
- Install Prezto with Pure prompt theme
- Install Meslo Nerd Font
- Symlink shell config and Ghostty config
- Back up any existing files before replacing them

**After install:** Set your terminal font to `MesloLGS NF`, then restart your terminal.

## Structure

```
dotfiles/
├── shell/
│   ├── .zshrc              # Main shell config (Prezto + Pure)
│   ├── .zpreztorc          # Prezto module and prompt config
│   ├── aliases.zsh         # All aliases
│   └── functions.zsh       # Custom functions
├── ghostty/
│   └── config              # Ghostty terminal settings
├── scripts/
│   └── install.sh          # One-time setup per machine
├── CLAUDE.md
├── README.md
└── .gitignore
```

## Local overrides

Create `~/.zshrc.local` (gitignored) for per-machine stuff:

```bash
# Extra PATH for this machine
export PATH="$HOME/some-tool/bin:$PATH"
```
