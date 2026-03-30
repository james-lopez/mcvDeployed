# ============================================
# Shell aliases
# ============================================

# --- Navigation ---
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias dev="cd ~/Documents/projects"

# --- Git (keep it short) ---
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate -20"
alias gnuke='echo "⚠️  This will destroy uncommitted changes. Ctrl+C to cancel." && read -q "?Continue? (y/n) " && echo && git clean -fd && git checkout .'

# --- React Native ---
alias rn="npx react-native"
alias rnios="npx react-native run-ios"
alias rnand="npx react-native run-android"
alias rnstart="npx react-native start --reset-cache"
alias pod="cd ios && pod install && cd .."
alias nuke-modules="rm -rf node_modules && rm -rf ios/Pods && npm install && cd ios && pod install && cd .."

# --- npm/yarn ---
alias ni="npm install"
alias nr="npm run"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"

# --- System ---
alias cls="clear"
alias ll="ls -lahF"
alias ports="lsof -i -P -n | grep LISTEN"
alias myip="curl -s ifconfig.me"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# --- Dotfiles ---
alias dotfiles="cd \$DOTFILES"
alias reload="source ~/.zshrc && echo '✅ Shell reloaded'"

# --- Claude Code ---
alias cc="claude"
alias ccc="claude --continue"
alias ccr="claude --resume"
