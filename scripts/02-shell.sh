#!/bin/bash
# ==============================================================================
# 02-shell.sh — FZF, Zoxide, Starship, Delta, Tmux config
# ==============================================================================

set -euo pipefail
source "$(dirname "$0")/00-helpers.sh"

install_fzf() {
  if [[ -d "$HOME/.fzf" ]]; then
    warn "FZF already installed — skipping."
    return
  fi
  info "Installing FZF..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  # --all enables key bindings (Ctrl+R, Ctrl+T, Alt+C) and shell completion
  "$HOME/.fzf/install" --all --no-update-rc
  success "FZF installed."
}

install_zoxide() {
  if command -v zoxide &>/dev/null; then
    warn "Zoxide already installed — skipping."
    return
  fi
  info "Installing Zoxide (smarter cd)..."
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  success "Zoxide installed."
}

install_starship() {
  if command -v starship &>/dev/null; then
    warn "Starship already installed — skipping."
    return
  fi
  info "Installing Starship prompt..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
  success "Starship installed."
}

install_delta() {
  if command -v delta &>/dev/null; then
    warn "Delta already installed — skipping."
    return
  fi
  info "Installing Delta (better git diffs)..."
  local VERSION
  VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" \
    | grep -Po '"tag_name": "\K[^"]*')
  curl -sLo /tmp/delta.deb \
    "https://github.com/dandavison/delta/releases/latest/download/git-delta_${VERSION}_amd64.deb"
  sudo dpkg -i /tmp/delta.deb
  rm /tmp/delta.deb
  success "Delta installed."
}

configure_tmux() {
  backup_if_exists "$HOME/.tmux.conf"
  info "Writing ~/.tmux.conf..."
  cp "$(dirname "$0")/../configs/tmux/.tmux.conf" "$HOME/.tmux.conf"
  success "Tmux configured."
}

setup_bashrc() {
  info "Updating ~/.bashrc with shell tool initializers..."

  append_if_missing '# FZF'
  append_if_missing '[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"'

  append_if_missing '# FZF — use fd + bat for better defaults'
  append_if_missing 'export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"'
  append_if_missing 'export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview \"bat --color=always --line-range :50 {}\""'
  append_if_missing 'export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"'
  append_if_missing 'export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"'

  append_if_missing '# Zoxide (smarter cd — use z instead of cd)'
  append_if_missing 'eval "$(zoxide init bash)"'

  append_if_missing '# Starship prompt'
  append_if_missing 'eval "$(starship init bash)"'

  success ".bashrc updated."
}

install_fzf
install_zoxide
install_starship
install_delta
configure_tmux
setup_bashrc
