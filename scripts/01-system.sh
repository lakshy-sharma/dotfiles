#!/bin/bash
# ==============================================================================
# 01-system.sh — APT packages, Neovim AppImage
# ==============================================================================

set -euo pipefail
source "$(dirname "$0")/00-helpers.sh"

NVIM_URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage"

install_apt_packages() {
  info "Updating apt and installing base packages..."
  sudo apt-get update -qq
  sudo apt-get install -y -qq \
    build-essential \
    clangd \
    bear \
    libfuse2 \
    xclip \
    tmux \
    curl \
    wget \
    git \
    unzip \
    fd-find \
    ripgrep \
    bat
  success "APT packages installed."
}

install_neovim() {
  if [[ -f "/usr/local/bin/nvim" ]]; then
    warn "Neovim already exists at /usr/local/bin/nvim — skipping."
    return
  fi
  info "Downloading Neovim stable AppImage..."
  wget -q "$NVIM_URL" -O /tmp/nvim
  chmod +x /tmp/nvim
  sudo mv /tmp/nvim /usr/local/bin/nvim
  success "Neovim installed."
}

# fd is installed as fdfind on Debian/Ubuntu — alias it
symlink_fd() {
  if command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    success "Symlinked fdfind → fd"
  fi
}

# bat is installed as batcat on Debian/Ubuntu — alias it
symlink_bat() {
  if command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    sudo ln -sf "$(which batcat)" /usr/local/bin/bat
    success "Symlinked batcat → bat"
  fi
}

install_apt_packages
install_neovim
symlink_fd
symlink_bat
