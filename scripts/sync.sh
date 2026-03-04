#!/bin/bash
# ============================================
# Dotfiles sync helper
# Usage: ./scripts/sync.sh [push|pull] [commit message]
# ============================================

set -e

DOTFILES="$HOME/dotfiles"
cd "$DOTFILES"

case "${1:-pull}" in
  pull)
    git pull
    source "$HOME/.zshrc"
    echo "✅ Dotfiles synced"
    ;;
  push)
    git add -A
    git commit -m "${2:-update dotfiles}"
    git push
    echo "✅ Dotfiles pushed"
    ;;
  *)
    echo "Usage: sync.sh [pull|push] [commit message]"
    exit 1
    ;;
esac
