#!/bin/bash

# ==============================================================================
# LUNARVIM & DEV ENVIRONMENT SETUP SCRIPT
# Target: Go, Python (Conda), C++, Node.js, Tmux, LazyGit
# ==============================================================================

set -e

# --- Colors for Output ---
NC='\033[0m'
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'

# --- Logging Functions ---
info() { echo -e "${BLUE}${BOLD}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}${BOLD}[SUCCESS]${NC} $1"; }
warn() { echo -e "${YELLOW}${BOLD}[WARN]${NC} $1"; }
error() { echo -e "${RED}${BOLD}[ERROR]${NC} $1"; exit 1; }

# --- Constants ---
GO_VERSION="1.26.1"
NODE_VERSION="24"
CONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
NVIM_URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage"

# 1. System Tools
install_system_tools() {
  info "Installing System Utilities (Tmux, xclip, libfuse2)..."
  sudo apt-get update -qq
  sudo apt-get install -y -qq libfuse2 xclip tmux build-essential clangd bear
  
  if [ ! -f "/usr/local/bin/nvim" ]; then
    info "Downloading Neovim AppImage..."
    wget -q "$NVIM_URL" -O nvim
    chmod +x nvim
    sudo mv nvim /usr/local/bin/nvim
  else
    warn "Neovim already exists at /usr/local/bin/nvim."
  fi
}

# 2. Node.js & NVM (Idempotent)
install_nodejs() {
  info "Configuring Node.js environment..."
  export NVM_DIR="$HOME/.nvm"
  
  if [ ! -d "$NVM_DIR" ]; then
    info "Installing NVM..."
    curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  fi

  # Load NVM without spawning a new shell
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  if ! command -v node &> /dev/null; then
    info "Installing Node.js $NODE_VERSION..."
    nvm install "$NODE_VERSION" -s
  else
    success "Node.js $(node -v) is already active."
  fi
}

# 3. Miniconda (Idempotent)
install_miniconda() {
  if [ ! -d "$HOME/miniconda" ]; then
    info "Installing Miniconda..."
    wget -q "$CONDA_URL" -O miniconda.sh
    bash miniconda.sh -b -p "$HOME/miniconda"
    rm miniconda.sh
  else
    warn "Miniconda directory already exists."
  fi
  eval "$($HOME/miniconda/bin/conda shell.bash hook)"
}

# 4. LazyGit (Idempotent)
install_lazygit() {
  if ! command -v lazygit &> /dev/null; then
    info "Installing LazyGit..."
    local VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit
  else
    success "LazyGit is already installed."
  fi
}

# 5. Go Language (Idempotent)
install_go() {
  if [ ! -d "/usr/local/go" ]; then
    info "Installing Go $GO_VERSION..."
    wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    rm "go${GO_VERSION}.linux-amd64.tar.gz"
  else
    warn "Go is already installed at /usr/local/go."
  fi
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
}

# 6. LunarVim (Idempotent)
install_lunarvim() {
  if [ ! -d "$HOME/.local/share/lunarvim" ]; then
    info "Installing LunarVim..."
    LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) --yes
  else
    warn "LunarVim is already installed."
  fi
}

# 7. Environment Configurations
configure_env() {
  info "Writing configuration files..."
  
  # LunarVim Configuration
  mkdir -p "$HOME/.config/lvim"
  cat <<EOF > "$HOME/.config/lvim/config.lua"
lvim.colorscheme = "evening"
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

lvim.builtin.treesitter.ensure_installed = { "go", "python", "cpp", "lua", "c" }
lvim.lsp.installer.setup.ensure_installed = { "gopls", "basedpyright", "clangd" }

-- Use Conda base for Python provider
vim.g.python3_host_prog = vim.fn.expand("\$HOME/miniconda/bin/python")

require("lvim.lsp.manager").setup("basedpyright", {
  settings = { basedpyright = { analysis = { typeCheckingMode = "basic", autoImportCompletions = true } } }
})
EOF

  # Tmux Configuration
  cat <<EOF > "$HOME/.tmux.conf"
set -g mouse on
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
set -s escape-time 0
EOF
}

# 8. Bashrc Persistence
setup_bashrc() {
  info "Updating .bashrc..."
  local LINES=(
    'export PATH=$PATH:/usr/local/go/bin:$HOME/.local/bin:$HOME/go/bin'
    'source $HOME/miniconda/etc/profile.d/conda.sh'
    '[ -s "$HOME/.nvm/nvm.sh" ] && \. "$HOME/.nvm/nvm.sh"'
  )
  for line in "${LINES[@]}"; do
    if ! grep -qF "$line" "$HOME/.bashrc"; then
      echo "$line" >> "$HOME/.bashrc"
    fi
  done
}

# --- Main Execution ---
main() {
  clear
  echo -e "${BOLD}${BLUE}Starting Development Environment Setup...${NC}\n"
  
  install_system_tools
  install_nodejs
  install_miniconda
  install_lazygit
  install_go
  install_lunarvim
  configure_env
  setup_bashrc
  
  echo -e "\n${GREEN}${BOLD}========================================================${NC}"
  success "Setup Complete!"
  info "1. Run: ${BOLD}source ~/.bashrc${NC}"
  info "2. Type: ${BOLD}tmux${NC} to start your multiplexer."
  info "3. Type: ${BOLD}lvim${NC} to start your editor."
  echo -e "${GREEN}${BOLD}========================================================${NC}"
}

main
