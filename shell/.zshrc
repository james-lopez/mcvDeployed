# ============================================
# .zshrc — sourced from ~/dotfiles
# ============================================

# --- Dotfiles location (resolved from .zshrc symlink) ---
export DOTFILES="$(dirname "$(readlink -f ~/.zshrc)")"
export DOTFILES="${DOTFILES%/shell}"

# --- Source Prezto ---
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# --- Path additions ---
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# --- Default editor ---
export EDITOR="cursor"
export VISUAL="cursor"

# --- History ---
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# --- Source dotfiles modules ---
[[ -f "$DOTFILES/shell/aliases.zsh" ]] && source "$DOTFILES/shell/aliases.zsh"
[[ -f "$DOTFILES/shell/functions.zsh" ]] && source "$DOTFILES/shell/functions.zsh"

# --- Local overrides (not committed — machine-specific stuff) ---
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# --- NVM (if installed) ---
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
