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

# Initialize and apply dotfiles
chezmoi init --apply https://github.com/malud/dotfiles.git

# Restart your shell
exec bash
```

That's it! Packages install automatically using the best method for your platform.

### What Gets Installed Automatically

**macOS:**
- Homebrew (if not present)
- All packages from Brewfile (60+ formulae, 6+ casks)
- Nerd Fonts, Ghostty, Docker Desktop, and more

**Linux:**
- **Ansible-based** declarative tool management
- Essential tools via native package manager (apt/dnf/yum/apk)
- Modern CLI tools: eza, bat, fd, ripgrep, fzf, gping, trippy
- Development tools: neovim (with Lazy.nvim), git, jq
- Network utilities: netcat, nmap, mtr
- Starship prompt via official installer
- kubectl krew plugins (if kubectl available)
- devpod docker provider (if devpod available)

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
├── dot_Brewfile.tmpl                           # Homebrew packages (macOS only)
├── run_once_before_install-homebrew.sh.tmpl    # Auto-install Homebrew (macOS)
├── run_once_install-packages.sh.tmpl           # Install packages via Homebrew (macOS)
├── run_once_install-modern-tools.sh.tmpl       # Install packages via native managers (Linux)
├── run_once_after_install-krew-plugins.sh.tmpl # Install kubectl krew plugins
├── run_once_after_install-devpod-provider.sh.tmpl  # Install devpod docker provider
├── run_onchange_update-brew.sh.tmpl            # Auto-update brew on changes (macOS)
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
- **Cross-platform** - Works on macOS and Linux with optimized package managers per platform
- **Automatic package management** - Homebrew on macOS, native package managers on Linux
- **Extensible** - Local overrides via `~/.bashrc.local`

## Automatic Package Management

### macOS - Homebrew

The dotfiles automatically manage packages via Homebrew on macOS:

1. **Auto-install Homebrew** if not present (non-interactive)
   - Uses standard Homebrew installation

2. **Install all packages** from the Brewfile
   - 60+ formulae (development tools, CLI utilities, system libraries)
   - 6+ casks (Ghostty, Docker Desktop, DevPod, ClickHouse, Proton Mail, OpenVPN Connect)
   - Nerd Fonts for proper icon rendering

3. **Keep packages in sync** across machines
   - Automatically install missing packages on `chezmoi apply`
   - Update Homebrew when Brewfile changes

### Linux - Native Package Managers

On Linux, the dotfiles use **native package managers** for better performance and reliability:

1. **Automatic detection** of your package manager (apt/dnf/yum/apk)

2. **Install essential tools** from native repositories
   - Modern CLI tools: bat, fd, ripgrep, fzf (via apt/dnf)
   - Development tools: neovim, tmux, git, jq (via apt/dnf)
   - Rust tools: eza, zoxide (via cargo for latest versions)
   - Cloud tools: kubectl, helm, k9s (via direct downloads)
   - Starship prompt (via official installer)
   - yq (via direct download - Go version)


## Updating

```bash
chezmoi update -v
```

## Remote/Container Usage

On a remote machine or dev container (chezmoi as feature):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply malud
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
