#!/bin/bash
# ==============================================================================
# 06-heavy.sh — Docker, kubectl, Terraform
# NOT run by default. Use: ./install.sh --all
# ==============================================================================

set -euo pipefail
source "$(dirname "$0")/00-helpers.sh"

install_docker() {
  if command -v docker &>/dev/null; then
    warn "Docker already installed — skipping."
    return
  fi
  info "Installing Docker Engine..."
  sudo apt-get update -qq
  sudo apt-get install -y -qq ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

  sudo apt-get update -qq
  sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Allow running Docker without sudo
  sudo usermod -aG docker "$USER"
  warn "Docker installed. You may need to log out and back in for group changes to take effect."
  success "Docker installed."
}

install_kubectl() {
  if command -v kubectl &>/dev/null; then
    warn "kubectl already installed — skipping."
    return
  fi
  info "Installing kubectl..."
  local VERSION
  VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)
  curl -sLo /tmp/kubectl "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
  rm /tmp/kubectl
  success "kubectl $VERSION installed."
}

info "Running heavy dependency installs: Docker, kubectl, Terraform..."
install_docker
install_kubectl
success "All heavy dependencies installed."
