#!/bin/bash
# ==============================================================================
# 04-git-tools.sh — LazyGit, GitHub CLI (gh)
# ==============================================================================

set -euo pipefail
source "$(dirname "$0")/00-helpers.sh"

install_lazygit() {
  if command -v lazygit &>/dev/null; then
    warn "LazyGit already installed — skipping."
    return
  fi
  info "Installing LazyGit..."
  local VERSION
  VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
    | grep -Po '"tag_name": "v\K[^"]*')
  curl -sLo /tmp/lazygit.tar.gz \
    "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${VERSION}_Linux_x86_64.tar.gz"
  tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
  sudo install /tmp/lazygit /usr/local/bin
  rm /tmp/lazygit.tar.gz /tmp/lazygit
  success "LazyGit installed."
}

install_gh_cli() {
  if command -v gh &>/dev/null; then
    warn "GitHub CLI already installed — skipping."
    return
  fi
  info "Installing GitHub CLI (gh)..."
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
    https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt-get update -qq
  sudo apt-get install -y -qq gh
  success "GitHub CLI installed."
}

configure_git() {
  info "Copying git config..."
  backup_if_exists "$HOME/.gitconfig"
  cp "$(dirname "$0")/../configs/git/.gitconfig" "$HOME/.gitconfig"
  success "Git configured (edit ~/.gitconfig to set your name/email)."
}

install_lazygit
install_gh_cli
configure_git
