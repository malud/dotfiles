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

# Initialize and apply dotfiles (everything else is automatic!)
chezmoi init --apply https://github.com/malud/dotfiles.git

# Restart your shell
exec bash
```

That's it! Homebrew, starship, and all packages install automatically.

### What Gets Installed Automatically

- **Homebrew** (both macOS and Linux) - installed non-interactively if not present
- **All packages from Brewfile** - starship, eza, bat, fd, ripgrep, zoxide, fzf, and more
- **kubectl krew plugins** - if kubectl is available
- **devpod docker provider** - if devpod is available

### Manual Preview (Optional)

If you want to preview changes before applying:

```bash
# Initialize without applying
chezmoi init https://github.com/malud/dotfiles.git

# Preview changes
chezmoi diff

# Apply dotfiles
chezmoi apply -v
```

## Structure

```
~/.local/share/chezmoi/
├── .chezmoiignore                              # Conditional file exclusions
├── .chezmoi.toml.tmpl                          # User configuration template
├── dot_bashrc                                  # Main bash configuration
├── dot_bash_profile                            # Bash login shell
├── dot_inputrc                                 # Readline configuration
├── dot_gitconfig.tmpl                          # Git configuration
├── dot_Brewfile.tmpl                           # Homebrew packages (cross-platform)
├── run_once_before_install-homebrew.sh.tmpl    # Auto-install Homebrew (macOS)
├── run_once_before_install-homebrew-linux.sh.tmpl  # Auto-install Homebrew (Linux)
├── run_once_install-packages.sh.tmpl           # Install packages via Homebrew
├── run_once_install-modern-tools.sh.tmpl       # Fallback: native package managers (Linux)
├── run_once_after_install-krew-plugins.sh.tmpl # Install kubectl krew plugins
├── run_once_after_install-devpod-provider.sh.tmpl  # Install devpod docker provider
├── run_onchange_update-brew.sh.tmpl            # Auto-update brew on changes
└── dot_config/
    ├── starship.toml                           # Starship prompt (Catppuccin Mocha)
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
- **Cross-platform** - Works on macOS and Linux (Ghostty config macOS-only)
- **Automatic Homebrew** - Installs and manages packages on both macOS and Linux
- **Smart fallback** - Uses native package managers on Linux if Homebrew fails
- **Extensible** - Local overrides via `~/.bashrc.local`

## Automatic Package Management

### Homebrew (macOS & Linux)

The dotfiles automatically install and manage Homebrew on both platforms:

1. **Auto-install Homebrew** if not present (non-interactive)
   - macOS: Uses standard Homebrew installation
   - Linux: Installs Linuxbrew/Homebrew for Linux

2. **Install all packages** from the Brewfile
   - 60+ formulae (development tools, CLI utilities, system libraries)
   - 6 casks (Ghostty, Docker, DevPod, ClickHouse, Proton Mail, OpenVPN Connect)
   - Nerd Fonts for proper icon rendering

3. **Keep packages in sync** across machines
   - Automatically install missing packages on `chezmoi apply`
   - Update Homebrew when Brewfile changes

4. **Smart fallback** (Linux only)
   - If Homebrew installation fails, falls back to native package managers (apt/dnf/yum/apk)
   - Ensures core tools are always installed

### macOS-Specific Features

On macOS, additional configuration includes:

1. **Ghostty terminal** with Catppuccin Mocha theme
2. **Cask applications** (Ghostty, Docker Desktop, etc.)

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

