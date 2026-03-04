# ============================================
# James's .zshrc — sourced from ~/dotfiles
# ============================================

# --- Dotfiles location ---
export DOTFILES="$HOME/dotfiles"

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git node npm docker zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

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

# --- Powerlevel10k config (generated per machine by p10k configure) ---
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
