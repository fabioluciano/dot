# 🏠 Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## 📋 Overview

This repository contains my personal configuration files for:

| Category | Applications |
|----------|--------------|
| **Shell** | zsh, zplug, starship |
| **Editor** | Neovim (AstroNvim) |
| **Terminal** | Alacritty, Ghostty, WezTerm |
| **Multiplexer** | tmux, tmuxp, smug |
| **Version Control** | Git, Git Delta |
| **Cloud/DevOps** | kubectl, k9s, Terraform, AWS CLI |
| **Runtime Manager** | mise |
| **Other** | bat, eza, fzf, zoxide, direnv |

## 🚀 Quick Start

### Install chezmoi and apply dotfiles

```bash
# macOS
brew install chezmoi
chezmoi init --apply fabioluciano

# Arch Linux
yay -S chezmoi
chezmoi init --apply fabioluciano
```

### Or one-liner

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply fabioluciano
```

## 🖥️ Supported Platforms

- **macOS** (Homebrew)
- **Linux** (Arch/Pacman + AUR)

## 📦 Package Management

### macOS (Homebrew)

```bash
# Install all packages from Brewfile
brew bundle --file=~/.Brewfile
```

### Arch Linux (Pacman + AUR)

```bash
# Using pacmanfile
pacmanfile sync ~/.Pacmanfile
```

### Kubernetes (Krew)

```bash
# Install kubectl plugins
cat ~/.Krewfile | xargs -I{} kubectl krew install {}
```

## 🔑 Key Features

### Cross-platform Support

Templates are used to handle platform-specific configurations:

```gotmpl
{{- if eq .chezmoi.os "darwin" }}
# macOS specific config
{{- else if eq .chezmoi.os "linux" }}
# Linux specific config
{{- end }}
```

### Shell Features

- **Lazy loading** - kubectl completion loads on first use
- **History** - 1M lines with deduplication
- **Completion** - Enhanced with fzf-tab
- **Aliases** - Organized shortcuts for common tools

### Terminal Features

- **Theme** - Tokyo Night across all terminals
- **Font** - CaskaydiaCove Nerd Font
- **Integration** - Auto-attach to tmux session

### Git Configuration

- **Delta** - Beautiful diffs with syntax highlighting
- **Aliases** - Comprehensive shortcuts
- **Safety** - Force push with lease, fetch prune

## 📁 Structure

```
.
├── dot_zshrc.tmpl           # Shell configuration
├── dot_Brewfile             # macOS packages
├── dot_Pacmanfile           # Arch Linux packages
├── dot_Krewfile             # kubectl plugins
├── private_dot_config/
│   ├── alacritty/           # Alacritty terminal
│   ├── ghostty/             # Ghostty terminal
│   ├── wezterm/             # WezTerm terminal
│   ├── git/                 # Git configuration
│   ├── nvim/                # Neovim (AstroNvim)
│   ├── tmux/                # tmux configuration
│   ├── tmuxp/               # tmuxp sessions
│   ├── smug/                # smug sessions
│   ├── k9s/                 # Kubernetes TUI
│   ├── mise/                # Runtime manager
│   ├── starship.toml        # Shell prompt
│   └── bat/                 # bat (cat replacement)
├── private_dot_gnupg/       # GPG agent configuration
└── dot_ssh/                 # SSH configuration
```

## 🔧 Usage

### Common Commands

```bash
# Check what would be changed
chezmoi diff

# Apply changes
chezmoi apply

# Edit a file and apply
chezmoi edit ~/.zshrc

# Update from remote repository
chezmoi update

# Add a new file
chezmoi add ~/.config/new-app/config
```

### tmux/tmuxp

```bash
# Start default session
tmuxp load ~/.config/tmuxp/tmuxp.yml

# Or with smug
smug start main
```

## ⚙️ Dependencies

### Required

- chezmoi
- zsh
- git

### Recommended

- [starship](https://starship.rs/) - Shell prompt
- [mise](https://mise.jdx.dev/) - Runtime version manager
- [eza](https://eza.rocks/) - Modern ls replacement
- [bat](https://github.com/sharkdp/bat) - cat with syntax highlighting
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Smarter cd
- [delta](https://github.com/dandavison/delta) - Git diff pager

## 📝 License

MIT License - Feel free to use and modify.

## 🤝 Contributing

This is a personal configuration repository, but feel free to use it as inspiration for your own dotfiles!

---

**Author:** Fábio Luciano
