#!/bin/bash
# ============================================
# dotfiles installer
# Run once per machine: ./scripts/install.sh
# ============================================

set -e

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

echo "🔧 Dotfiles installer"
echo "=============================="
echo "   Installing from: $DOTFILES"
echo ""

# Check we're in the right place
if [[ ! -f "$DOTFILES/README.md" ]]; then
  echo "❌ Not a valid dotfiles repo: $DOTFILES"
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

# --- Clean up Oh My Zsh / Powerlevel10k if present ---
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo ""
  echo "🧹 Removing Oh My Zsh (replaced by Prezto)..."
  rm -rf "$HOME/.oh-my-zsh"
  rm -f "$HOME/.p10k.zsh"
  rm -rf "$HOME/.cache/p10k-"*
  echo "   ✅ Removed"
fi

# --- Prezto ---
echo ""
echo "🐚 Prezto..."
if [[ ! -d "$HOME/.zprezto" ]]; then
  echo "   Installing Prezto..."
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"
else
  echo "   ✅ Already installed"
fi

# --- Meslo Nerd Font ---
echo ""
echo "🔤 Meslo Nerd Font..."
if ls ~/Library/Fonts/MesloLGS* &>/dev/null; then
  echo "   ✅ Already installed"
else
  echo "   Installing via Homebrew..."
  brew install font-meslo-lg-nerd-font 2>/dev/null || {
    echo "   ⚠️  Couldn't install font automatically"
    echo "   Manual install: brew install font-meslo-lg-nerd-font"
  }
fi

# --- Shell config ---
echo ""
echo "🐚 Shell config..."
link_file "$DOTFILES/shell/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES/shell/.zpreztorc" "$HOME/.zpreztorc"

# --- Ghostty config ---
echo ""
echo "👻 Ghostty config..."
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
mkdir -p "$GHOSTTY_CONFIG_DIR"
link_file "$DOTFILES/ghostty/config" "$GHOSTTY_CONFIG_DIR/config"

echo ""
echo "=============================="
echo "✅ Done! Restart your terminal or run: exec zsh"
echo ""
echo "Pro tip: Create ~/.zshrc.local for machine-specific overrides"
echo ""
