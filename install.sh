#!/bin/bash
# ==============================================================================
# DOTFILES - Main Orchestrator
# Usage:
#   ./install.sh              # Run everything (except heavy)
#   ./install.sh --all        # Run everything including heavy deps
#   ./install.sh --only 02    # Run only a specific script by prefix number
#   ./install.sh --skip 06    # Skip a specific script
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR/scripts"

# --- Colors ---
NC='\033[0m'; BOLD='\033[1m'
GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; RED='\033[0;31m'

info()    { echo -e "${BLUE}${BOLD}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}${BOLD}[OK]${NC}    $1"; }
warn()    { echo -e "${YELLOW}${BOLD}[WARN]${NC}  $1"; }
error()   { echo -e "${RED}${BOLD}[ERROR]${NC} $1"; exit 1; }
header()  { echo -e "\n${BOLD}${BLUE}━━━  $1  ━━━${NC}"; }

# --- Argument Parsing ---
RUN_HEAVY=false
ONLY_PREFIX=""
SKIP_PREFIX=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)        RUN_HEAVY=true ;;
    --only)       ONLY_PREFIX="$2"; shift ;;
    --skip)       SKIP_PREFIX="$2"; shift ;;
    -h|--help)
      echo "Usage: ./install.sh [--all] [--only <prefix>] [--skip <prefix>]"
      echo "  --all          Include heavy dependencies (Docker, kubectl, etc.)"
      echo "  --only <nn>    Run only the script with this number prefix (e.g. 02)"
      echo "  --skip <nn>    Skip the script with this number prefix"
      exit 0
      ;;
    *) warn "Unknown flag: $1" ;;
  esac
  shift
done

# --- Runner ---
run_script() {
  local script="$1"
  local name
  name=$(basename "$script")

  header "Running: $name"
  if bash "$script"; then
    success "$name completed."
  else
    error "$name failed. Aborting."
  fi
}

clear
echo -e "${BOLD}${BLUE}"
echo "  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗"
echo "  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝"
echo "  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗"
echo "  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║"
echo "  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║"
echo "  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝"
echo -e "${NC}"
info "Starting dotfiles setup... (Run with --all to include Docker/kubectl)"
echo ""

for script in "$SCRIPTS_DIR"/[0-9][0-9]-*.sh; do
  [[ -f "$script" ]] || continue

  prefix=$(basename "$script" | cut -c1-2)

  # Skip heavy script unless --all
  if [[ "$prefix" == "06" && "$RUN_HEAVY" == false ]]; then
    warn "Skipping 06-heavy.sh (use --all to include Docker, kubectl, etc.)"
    continue
  fi

  # --only filter
  if [[ -n "$ONLY_PREFIX" && "$prefix" != "$ONLY_PREFIX" ]]; then
    continue
  fi

  # --skip filter
  if [[ -n "$SKIP_PREFIX" && "$prefix" == "$SKIP_PREFIX" ]]; then
    warn "Skipping script with prefix $SKIP_PREFIX as requested."
    continue
  fi

  run_script "$script"
done

echo ""
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════${NC}"
success "All done! Next steps:"
info "  1. source ~/.bashrc"
info "  2. tmux            — start your multiplexer"
info "  3. lvim            — start your editor"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════${NC}\n"
