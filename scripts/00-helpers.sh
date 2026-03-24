#!/bin/bash
# ==============================================================================
# Shared helpers — sourced by all scripts, not run directly
# ==============================================================================

# --- Colors ---
NC='\033[0m'; BOLD='\033[1m'
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'

info()    { echo -e "${BLUE}${BOLD}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}${BOLD}[OK]${NC}    $1"; }
warn()    { echo -e "${YELLOW}${BOLD}[WARN]${NC}  $1"; }
error()   { echo -e "${RED}${BOLD}[ERROR]${NC} $1"; exit 1; }

# Backup a file if it exists, timestamped
backup_if_exists() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local backup="${file}.bak.$(date +%Y%m%d%H%M%S)"
    cp "$file" "$backup"
    warn "Backed up $(basename "$file") → $(basename "$backup")"
  fi
}

# Append a line to a file only if it isn't already present
append_if_missing() {
  local line="$1"
  local file="${2:-$HOME/.bashrc}"
  if ! grep -qF "$line" "$file"; then
    echo "$line" >> "$file"
  fi
}
