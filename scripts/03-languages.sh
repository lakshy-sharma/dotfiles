#!/bin/bash
# ==============================================================================
# 03-languages.sh — Go 1.26.1, Node.js via NVM, Python via Miniconda
# ==============================================================================

set -euo pipefail
source "$(dirname "$0")/00-helpers.sh"

GO_VERSION="1.26.1"
NODE_VERSION="24"
CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

# --- Go ---
install_go() {
  # Check if correct version is already installed
  local installed_ver=""
  if [[ -x "/usr/local/go/bin/go" ]]; then
    installed_ver=$(/usr/local/go/bin/go version | awk '{print $3}' | sed 's/go//')
  fi

  if [[ "$installed_ver" == "$GO_VERSION" ]]; then
    warn "Go $GO_VERSION already installed — skipping."
    return
  fi

  if [[ -n "$installed_ver" ]]; then
    info "Upgrading Go $installed_ver → $GO_VERSION..."
    sudo rm -rf /usr/local/go
  else
    info "Installing Go $GO_VERSION..."
  fi

  local archive="go${GO_VERSION}.linux-amd64.tar.gz"
  wget -q "https://go.dev/dl/${archive}" -O "/tmp/${archive}"
  sudo tar -C /usr/local -xzf "/tmp/${archive}"
  rm "/tmp/${archive}"
  success "Go $GO_VERSION installed."
}

# --- Node.js via NVM ---
install_nodejs() {
  export NVM_DIR="$HOME/.nvm"

  if [[ ! -d "$NVM_DIR" ]]; then
    info "Installing NVM..."
    curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  fi

  # Load NVM in this shell
  [[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"

  if ! nvm ls "$NODE_VERSION" &>/dev/null; then
    info "Installing Node.js $NODE_VERSION via NVM..."
    nvm install "$NODE_VERSION" -s
    nvm alias default "$NODE_VERSION"
  else
    success "Node.js $NODE_VERSION already installed."
  fi
}

# --- Python via Miniconda ---
install_miniconda() {
  if [[ -d "$HOME/miniconda" ]]; then
    warn "Miniconda already installed — skipping."
  else
    info "Installing Miniconda..."
    wget -q "$CONDA_URL" -O /tmp/miniconda.sh
    bash /tmp/miniconda.sh -b -p "$HOME/miniconda"
    rm /tmp/miniconda.sh
    success "Miniconda installed."
  fi
  eval "$($HOME/miniconda/bin/conda shell.bash hook)"
}

# --- .bashrc entries ---
setup_bashrc() {
  info "Updating ~/.bashrc for Go, NVM, and Conda..."

  append_if_missing '# Go'
  append_if_missing 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin'

  append_if_missing '# NVM'
  append_if_missing 'export NVM_DIR="$HOME/.nvm"'
  append_if_missing '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
  append_if_missing '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'

  append_if_missing '# Conda'
  append_if_missing 'source "$HOME/miniconda/etc/profile.d/conda.sh"'

  success ".bashrc updated."
}

install_go
install_nodejs
install_miniconda
setup_bashrc
