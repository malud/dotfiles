# Dotfiles

Portable bash-based dotfiles managed with chezmoi, themed with Catppuccin.

## Why Bash?

**Bash is the superior choice for portable dotfiles:**

- **Universal availability** - Pre-installed on every Linux, macOS, BSD, and WSL system
- **Zero-friction remote work** - SSH into any server and your shell just works
- **Container-native** - Works immediately in dev containers without installing extras
- **Fast startup** - Lower overhead than zsh, instant prompt with starship
- **Production standard** - What you'll find on production servers
- **Sufficient modern features** - Bash 4.0+ has everything needed for daily use

When combined with starship for prompts, you get 95% of zsh's visual appeal with 100% portability.

## Quick Start

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Install starship
curl -sS https://starship.rs/install.sh | sh

# Initialize with this repo
chezmoi init https://github.com/malud/dotfiles.git

# Preview changes
chezmoi diff

# Apply dotfiles
chezmoi apply -v
```

## Structure

```
~/.local/share/chezmoi/
├── .chezmoiignore                    # Conditional file exclusions
├── .chezmoi.toml.tmpl                # User configuration template
├── dot_bashrc                        # Main bash configuration
├── dot_bash_profile                  # Bash login shell
├── dot_inputrc                       # Readline configuration
├── dot_gitconfig.tmpl                # Git configuration
├── dot_Brewfile.tmpl                 # Homebrew packages (macOS only)
├── run_once_install-packages.sh.tmpl # Auto-install brew packages (macOS)
├── run_onchange_update-brew.sh.tmpl  # Auto-update brew on changes
└── dot_config/
    ├── starship.toml                 # Starship prompt (Catppuccin Mocha)
    ├── nvim/
    │   └── init.lua                  # Neovim config (Catppuccin Mocha)
    ├── ghostty/
    │   └── config                    # Ghostty terminal (macOS only)
    └── k9s/
        ├── config.yaml               # k9s configuration
        └── skins/
            └── catppuccin-mocha.yaml # k9s theme
```

## Features

- **Catppuccin Mocha** theme throughout (Ghostty, Starship, Neovim, k9s, fzf)
- **Neovim** as default editor with lazy.nvim and essential plugins
- **Starship** prompt with powerline glyphs
- **Smart history** - Large history, deduplication, append mode
- **Sensible defaults** - Minimal but functional
- **Cross-platform** - Ghostty config only applied on macOS
- **Homebrew automation** - Auto-install all your packages on new macOS machines
- **Extensible** - Local overrides via `~/.bashrc.local`

## macOS Features

On macOS, the dotfiles will automatically:

1. **Install all your Homebrew packages** from the Brewfile
   - 60+ formulae (development tools, CLI utilities, system libraries)
   - 6 casks (Ghostty, Docker, DevPod, ClickHouse, Proton Mail, OpenVPN Connect)
   - Nerd Fonts for proper icon rendering

2. **Keep packages in sync** across machines
   - Automatically install missing packages on `chezmoi apply`
   - Update Homebrew when Brewfile changes

3. **Configure Ghostty terminal** with Catppuccin Mocha theme

### Brewfile Highlights

**Development:**
- Languages: Go, Python 3.12/3.13 (with uv + ruff)
- Tools: Neovim, tmux, Git, fzf
- Note: Node.js managed in devcontainers

**Cloud & DevOps:**
- AWS CLI, Azure CLI, Terraform
- Kubernetes (kubectl, helm, k9s, kustomize, krew + oidc-login plugin)
- Docker

**Modern CLI Tools:**
- eza (better ls), bat (better cat), fd (better find)
- ripgrep (better grep), fzf (fuzzy finder), zoxide (smarter cd)
- yazi, fastfetch, just, jq, yq, z

**Security:**
- ClamAV, Yara

## Updating

```bash
chezmoi update -v
```

## Remote/Container Usage

On a remote machine or dev container:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply malud
curl -sS https://starship.rs/install.sh | sh
```

Your environment is instantly configured.

## Managing Homebrew Packages

### Add a new package
```bash
# Install it first
brew install newtool

# Update your Brewfile
chezmoi edit ~/.Brewfile

# Commit the change
chezmoi cd
git add dot_Brewfile.tmpl
git commit -m "Add newtool"
git push
```

### Sync packages to other Macs
```bash
chezmoi update -v  # Pulls changes and runs install script
```

### Manual Brewfile operations
```bash
# Install from Brewfile
brew bundle --file=~/.Brewfile

# Update all packages
brew update && brew upgrade

# Cleanup
brew cleanup
```

