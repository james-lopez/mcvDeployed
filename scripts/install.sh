#!/bin/bash
# ============================================
# james-dotfiles installer
# Run once per machine: ./scripts/install.sh
# ============================================

set -e

DOTFILES="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

echo "🔧 James's dotfiles installer"
echo "=============================="
echo ""

# Check we're in the right place
if [[ ! -f "$DOTFILES/README.md" ]]; then
  echo "❌ Expected dotfiles at ~/dotfiles"
  echo "   Run: git clone <your-repo> ~/dotfiles"
  exit 1
fi

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo "📦 Backing up existing configs to: $BACKUP_DIR"

# --- Helper: backup then symlink ---
link_file() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "   Backing up: $dest"
    mkdir -p "$(dirname "$BACKUP_DIR/${dest#$HOME/}")"
    cp -r "$dest" "$BACKUP_DIR/${dest#$HOME/}"
  fi

  rm -rf "$dest"
  mkdir -p "$(dirname "$dest")"
  ln -sf "$src" "$dest"
  echo "   ✅ $dest → $src"
}

# --- Helper: backup then copy ---
copy_file() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "   Backing up: $dest"
    mkdir -p "$(dirname "$BACKUP_DIR/${dest#$HOME/}")"
    cp -r "$dest" "$BACKUP_DIR/${dest#$HOME/}"
  fi

  rm -rf "$dest"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "   ✅ $dest ← $src (copied)"
}

# --- Oh My Zsh ---
echo ""
echo "🐚 Oh My Zsh..."
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "   Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "   ✅ Already installed"
fi

# --- Powerlevel10k theme ---
echo ""
echo "🎨 Powerlevel10k..."
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [[ ! -d "$P10K_DIR" ]]; then
  echo "   Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
else
  echo "   ✅ Already installed"
fi

# --- Meslo Nerd Font (required by Powerlevel10k) ---
echo ""
echo "🔤 Meslo Nerd Font..."
if fc-list 2>/dev/null | grep -qi "MesloLGS" || ls ~/Library/Fonts/MesloLGS* &>/dev/null; then
  echo "   ✅ Already installed"
else
  echo "   Installing via Homebrew..."
  brew install font-meslo-lg-nerd-font 2>/dev/null || {
    echo "   ⚠️  Couldn't install font automatically"
    echo "   Manual install: https://github.com/romkatv/powerlevel10k#fonts"
  }
fi

# --- Shell config ---
echo ""
echo "🐚 Shell config..."
link_file "$DOTFILES/shell/.zshrc" "$HOME/.zshrc"

# --- Claude Code config ---
echo ""
echo "🤖 Claude Code config..."
mkdir -p "$HOME/.claude"
# Copy settings.json (not symlink) so job() can overwrite it safely
copy_file "$DOTFILES/claude-code/settings.json" "$HOME/.claude/settings.json"
# Symlink CLAUDE.md (doesn't change per-job)
link_file "$DOTFILES/claude-code/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

# --- Cursor settings ---
echo ""
echo "📝 Cursor settings..."
CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
if [[ -d "$CURSOR_USER_DIR" ]] || [[ -d "$(dirname "$CURSOR_USER_DIR")" ]]; then
  mkdir -p "$CURSOR_USER_DIR"
  link_file "$DOTFILES/cursor/settings.json" "$CURSOR_USER_DIR/settings.json"
else
  echo "   ⚠️  Cursor not found — skipping (install Cursor first, then re-run)"
fi

# --- Dependencies check ---
echo ""
echo "🔑 Checking dependencies..."
if ! command -v jq &> /dev/null; then
  echo "   ⚠️  jq not found — job profile merging won't work"
  echo "   Fix: brew install jq"
else
  echo "   ✅ jq found"
fi

if ! command -v git &> /dev/null; then
  echo "   ❌ git not found — something is very wrong"
else
  echo "   ✅ git found"
fi

echo ""
echo "=============================="
echo "✅ Done! Restart your terminal or run: source ~/.zshrc"
echo ""
echo "⚠️  If this is a fresh machine, Powerlevel10k's config wizard will"
echo "   launch on next terminal open. Set your preferred font in your"
echo "   terminal app to 'MesloLGS NF' first."
echo ""
echo "Next steps:"
echo "  1. Edit jobs/crunchyroll/.gitconfig with your Crunchyroll email"
echo "  2. Edit jobs/mcd/.gitconfig with your MCD email"
echo "  3. Edit jobs/orka/.gitconfig with your Orka email"
echo "  4. Review jobs/personal/.gitconfig (already set)"
echo "  5. Run 'job crunchyroll' to switch to Crunchyroll context"
echo ""
echo "Pro tip: Add to ~/.zshrc.local on each machine for machine-specific stuff"
echo "  e.g.: export CURRENT_JOB=\"startup\"  # auto-set on your startup laptop"
