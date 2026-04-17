#!/bin/bash
# ==============================================================================
# 05-editors.sh — LunarVim
# Runs after 03-languages.sh so that Go, Node, and Conda are available
# ==============================================================================

set -euo pipefail
source "$(dirname "$0")/00-helpers.sh"

# Ensure PATH is populated (may not be set if sourced fresh)
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin:$HOME/.local/bin
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"

install_lunarvim() {
  if [[ -d "$HOME/.local/share/lunarvim" ]]; then
    warn "LunarVim already installed — skipping."
    return
  fi
  info "Installing LunarVim (this may take a few minutes)..."
  LV_BRANCH='release-1.4/neovim-0.9' \
    bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) --yes
  success "LunarVim installed."
}

configure_lunarvim() {
  local config_dir="$HOME/.config/lvim"
  mkdir -p "$config_dir"
  backup_if_exists "$config_dir/config.lua"
  info "Copying LunarVim config..."
  cp "$(dirname "$0")/../configs/lvim/config.lua" "$config_dir/config.lua"
  success "LunarVim configured."
}

setup_bashrc() {
  append_if_missing '# LunarVim'
  append_if_missing 'export PATH=$PATH:$HOME/.local/bin'
}

install_lunarvim
configure_lunarvim
setup_bashrc
