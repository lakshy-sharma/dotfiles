# dotfiles

Personal dev environment for Go, Python (Conda), C++, Node.js — powered by LunarVim, Tmux, and a curated set of CLI tools.

## What's included

| Script | What it installs |
|---|---|
| `01-system.sh` | Neovim, ripgrep, fd, bat, build-essential, clangd |
| `02-shell.sh` | FZF, Zoxide, Starship prompt, Delta, Tmux config |
| `03-languages.sh` | Go 1.26.1, Node.js 24 (via NVM), Python (via Miniconda) |
| `04-git-tools.sh` | LazyGit, GitHub CLI (gh), git config with delta |
| `05-editors.sh` | LunarVim with LSPs for Go, Python, C++ |
| `06-heavy.sh` | Docker, kubectl, Terraform _(opt-in)_ |

## Quick start

```bash
git clone https://github.com/yourname/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh scripts/*.sh
./install.sh
```

After install:
```bash
source ~/.bashrc
tmux       # start multiplexer
lvim       # start editor
```

## Options

```bash
./install.sh              # Everything except Docker/kubectl/Terraform
./install.sh --all        # Everything including heavy deps
./install.sh --only 03    # Only run 03-languages.sh
./install.sh --skip 05    # Skip editors (useful for servers)
```

## First-time editor setup

Open LunarVim and let it finish installing plugins:
```bash
lvim
# Wait for plugins to install, then restart
```

LSPs installed automatically: `gopls`, `basedpyright`, `clangd`

## Key bindings cheatsheet

### Tmux (prefix: `Ctrl+a`)
| Key | Action |
|---|---|
| `prefix \|` | Split horizontal |
| `prefix -` | Split vertical |
| `prefix h/j/k/l` | Navigate panes |
| `prefix r` | Reload config |

### FZF
| Key | Action |
|---|---|
| `Ctrl+R` | Search shell history |
| `Ctrl+T` | Search files (with bat preview) |
| `Alt+C` | Jump to directory |

### Zoxide
| Command | Action |
|---|---|
| `z proj` | Jump to most frecent match for "proj" |
| `zi` | Interactive jump with fzf |

## Updating individual components

```bash
# Update Go
./install.sh --only 03

# Update git tools only
./install.sh --only 04
```

## After updating `.gitconfig`

Set your name and email:
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
