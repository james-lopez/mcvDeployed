# ============================================
# James's shell functions — the good stuff
# ============================================

# --- Dotfiles push (function, not alias — needs args) ---
function dotpush() {
  cd ~/dotfiles && git add -A && git commit -m "${1:-update dotfiles}" && git push && echo '✅ Dotfiles pushed'
}

# --- Job Context Switcher ---
# Usage: job crunchyroll | job mcd | job orka | job personal
function job() {
  local profile="$1"
  local dotfiles_dir="$HOME/dotfiles"
  local jobs_dir="$dotfiles_dir/jobs"

  if [[ -z "$profile" ]]; then
    echo "Current job: ${CURRENT_JOB:-not set}"
    echo "Available: crunchyroll, mcd, orka, personal"
    return 0
  fi

  if [[ ! -d "$jobs_dir/$profile" ]]; then
    echo "❌ Unknown job profile: $profile"
    echo "Available: crunchyroll, mcd, orka, personal"
    return 1
  fi

  # Apply git config for this job
  if [[ -f "$jobs_dir/$profile/.gitconfig" ]]; then
    local name=$(git config --file "$jobs_dir/$profile/.gitconfig" user.name)
    local email=$(git config --file "$jobs_dir/$profile/.gitconfig" user.email)
    git config --global user.name "$name"
    git config --global user.email "$email"
    echo "🔧 Git identity: $name <$email>"
  fi

  # Apply Claude Code overrides for this job
  if [[ -f "$jobs_dir/$profile/claude.json" ]]; then
    local claude_settings="$HOME/.claude/settings.json"
    local base_settings="$dotfiles_dir/claude-code/settings.json"

    if command -v jq &> /dev/null; then
      local merged=$(jq -s '.[0] * .[1]' "$base_settings" "$jobs_dir/$profile/claude.json")
      echo "$merged" > "$claude_settings"
    else
      cp "$base_settings" "$claude_settings"
      echo "⚠️  Install jq for per-job Claude overrides: brew install jq"
    fi
    echo "🤖 Claude Code settings updated for: $profile"
  fi

  export CURRENT_JOB="$profile"
  echo "✅ Switched to: $profile"
}

# --- Quick project finder ---
function proj() {
  local search="$1"
  if [[ -z "$search" ]]; then
    echo "Usage: proj <search term>"
    return 1
  fi
  local result=$(find ~/dev -maxdepth 3 -type d -name "*${search}*" 2>/dev/null | head -5)
  if [[ -z "$result" ]]; then
    echo "No projects matching: $search"
    return 1
  fi
  local count=$(echo "$result" | wc -l | tr -d ' ')
  if [[ "$count" -eq 1 ]]; then
    cd "$result"
    echo "📁 $(pwd)"
  else
    echo "Multiple matches:"
    echo "$result" | nl
    echo -n "Pick a number: "
    read choice
    local target=$(echo "$result" | sed -n "${choice}p")
    if [[ -n "$target" ]]; then
      cd "$target"
      echo "📁 $(pwd)"
    fi
  fi
}

# --- Make directory and cd into it ---
function mkcd() {
  mkdir -p "$1" && cd "$1"
}

# --- Quick HTTP server ---
function serve() {
  local port="${1:-8000}"
  echo "🌐 Serving on http://localhost:$port"
  python3 -m http.server "$port"
}

# --- Extract any archive ---
function extract() {
  if [[ -f "$1" ]]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"    ;;
      *.tar.gz)    tar xzf "$1"    ;;
      *.bz2)       bunzip2 "$1"    ;;
      *.gz)        gunzip "$1"     ;;
      *.tar)       tar xf "$1"     ;;
      *.zip)       unzip "$1"      ;;
      *.7z)        7z x "$1"       ;;
      *)           echo "❌ Can't extract: $1" ;;
    esac
  else
    echo "❌ Not a file: $1"
  fi
}

# --- Kill process on port ---
function killport() {
  local port="$1"
  if [[ -z "$port" ]]; then
    echo "Usage: killport <port>"
    return 1
  fi
  local pid=$(lsof -ti :$port)
  if [[ -n "$pid" ]]; then
    kill -9 $pid
    echo "💀 Killed PID $pid on port $port"
  else
    echo "Nothing running on port $port"
  fi
}
