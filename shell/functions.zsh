# ============================================
# Shell functions
# ============================================

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
