# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io), targeting
**macOS** (Homebrew) and **Arch Linux** (pacman/yay).

## Bootstrap

On a fresh machine (installs chezmoi, pulls this repo, and applies it):

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply fabioluciano
```

Or, if chezmoi is already installed:

```sh
chezmoi init --apply https://github.com/fabioluciano/dot.git
```

### Prerequisites

- A Bitwarden vault unlocked via the `bw` CLI (`bw login && bw unlock`) — used
  to populate tokens/API keys in `~/.zshenv`. The expected item is named
  `dotfiles-tokens`.
- A YubiKey for GPG/SSH commit signing (the `run_before_*` scripts derive the
  public key and `allowed_signers`; signing degrades gracefully if absent).

## What's managed

| Manifest        | Target            | Installed by                                   |
| --------------- | ----------------- | ---------------------------------------------- |
| `dot_Brewfile`  | `~/.Brewfile`     | `brew bundle --global` (macOS)                 |
| `dot_Pacmanfile`| `~/.Pacmanfile`   | `yay`/`paru`/`pacman -S --needed` (Arch)       |
| `dot_Krewfile`  | `~/.Krewfile`     | `kubectl krew install` (kubectl plugins)       |
| mise            | `~/.config/mise`  | `mise install`                                 |

Package installs run automatically on `chezmoi apply` via the
`run_onchange_after_*` scripts in `.chezmoiscripts/` — they re-run only when the
corresponding manifest changes (tracked by its content hash).

## Day-to-day

```sh
chezmoi edit <file>     # edit a source file in $EDITOR
chezmoi diff            # preview pending changes
chezmoi apply           # apply (and run package sync if a manifest changed)
chezmoi update          # pull latest from the repo and apply
topgrade                # update everything (system, brew, mise, plugins, …)
```

## Layout

- `dot_zshrc.tmpl`, `private_dot_zshenv.tmpl`, `dot_zsh_plugins*.txt.tmpl` — zsh
  (antidote static bundle, cached completions, lazy tool init).
- `private_dot_config/` — app configs (nvim/AstroNvim, tmux, ghostty, k9s, jj,
  starship, mise, aerospace, espanso, …).
- `private_dot_config/git/`, `private_dot_gnupg/`, `private_dot_ssh/` — git
  identity + SSH-based commit signing via YubiKey.
- `.chezmoiscripts/` — `run_before_*` (YubiKey key material) and
  `run_onchange_after_*` (package sync).
