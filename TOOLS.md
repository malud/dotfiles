# Modern CLI Tools

These dotfiles automatically install modern CLI replacements for traditional Unix tools, giving you a better command-line experience that works everywhere.

## 🚀 Automatically Installed

All these tools are **automatically installed** when you apply the dotfiles:

- **macOS**: Via Homebrew (`brew bundle`)
- **Linux/Containers**: Via package manager or Cargo (`run_once_install-modern-tools.sh`)

### Tool Overview

| Tool | Replaces | Why Better |
|------|----------|------------|
| **eza** | `ls` | Colors, icons, git integration, tree view |
| **bat** | `cat` | Syntax highlighting, line numbers, git diff, paging |
| **fd** | `find` | Faster, intuitive syntax, respects .gitignore |
| **ripgrep (rg)** | `grep` | Blazing fast, regex support, respects .gitignore |
| **fzf** | - | Fuzzy finder for files, history, directories |
| **zoxide** | `cd` | Smarter navigation, learns your habits |

## 📝 Usage Examples

### eza - Better ls
```bash
ls              # Automatic via alias
ll              # Long format with git status
la              # Show hidden files
eza --tree      # Tree view
```

### bat - Better cat
```bash
cat file.py     # Automatic via alias (shows syntax highlighting)
bat --style=plain file.py  # Plain output, no decorations
```

### fd - Better find
```bash
fd pattern                  # Search for files
fd '^config' --extension md # Regex + extension filter
fd --type f --hidden        # Include hidden files
```

### ripgrep - Better grep
```bash
rg "pattern"                # Search in current dir
rg "TODO" --type rust       # Search only in Rust files
rg --hidden --no-ignore     # Include hidden/ignored files
```

### fzf - Fuzzy Finder
```bash
# Ctrl+T  - Search files
# Ctrl+R  - Search command history  
# Alt+C   - Search directories

# Use in commands
vim $(fzf)                  # Open file with fuzzy search
cd $(fd --type d | fzf)     # cd with fuzzy search
```

### zoxide - Smarter cd
```bash
z project       # Jump to ~/code/project (learns from history)
zi              # Interactive directory picker
z -             # Go back to previous directory
```

## 🎨 Integration with Bash

These tools are integrated into your `.bashrc`:

```bash
# Automatic aliases (if tools are available)
command -v eza &>/dev/null && alias ls='eza' && alias ll='eza -alh'
command -v bat &>/dev/null && alias cat='bat'
command -v fd &>/dev/null && alias find='fd'
command -v rg &>/dev/null && alias grep='rg'

# Zoxide initialization
eval "$(zoxide init bash)"

# FZF with Catppuccin Mocha theme
export FZF_DEFAULT_OPTS="--color=bg+:#313244,bg:#1e1e2e,..."
```

## 📦 Manual Installation (if needed)

If you want to install these tools manually on a system without the dotfiles:

### macOS
```bash
brew install eza bat fd ripgrep fzf zoxide
```

### Debian/Ubuntu
```bash
sudo apt-get update
sudo apt-get install bat fd-find ripgrep fzf

# Note: bat → batcat, fd → fdfind on Debian/Ubuntu
# Symlinks are created automatically by the install script

# eza and zoxide via cargo
cargo install eza zoxide
```

### Fedora/RHEL
```bash
sudo dnf install bat fd-find ripgrep fzf
cargo install eza zoxide
```

### Alpine Linux (containers)
```bash
apk add bat fd ripgrep fzf
cargo install eza zoxide
```

### Via Cargo (any Linux)
```bash
cargo install eza bat fd-find ripgrep zoxide
```

## 🌟 Why These Tools?

1. **Performance**: Written in Rust, incredibly fast
2. **User-Friendly**: Better defaults, colored output, intuitive syntax
3. **Git-Aware**: Respect `.gitignore`, show git status
4. **Cross-Platform**: Work on macOS, Linux, Windows
5. **Drop-in Replacements**: Aliases make transition seamless

## 🎯 Fonts

For proper icon rendering with `eza`, install a Nerd Font:

### macOS
```bash
brew install --cask font-jetbrains-mono-nerd-font
brew install --cask font-fira-code-nerd-font
brew install --cask font-hack-nerd-font
```

### Manual
Download from [Nerd Fonts](https://www.nerdfonts.com/)

Recommended: **JetBrains Mono Nerd Font** (already configured in Ghostty)

## 🐍 Python Development

Python development uses **uv** (ultra-fast Python package manager) with **ruff** (fast formatter/linter):

### uv - Modern Python Package Manager
```bash
# Create a new project
uv init myproject
cd myproject

# Create virtual environment
uv venv

# Install packages
uv add requests pandas
# uv pip install requests pandas

# Install from requirements.txt
uv pip install -r requirements.txt

# Run Python with managed versions
uv python install 3.13
uv run python script.py
```

### Configured Aliases
```bash
pip='uv pip'                    # Use uv for package management
venv='uv venv'                  # Create venvs with uv
python-install='uv python install'  # Install Python versions
python-list='uv python list'    # List available Python versions
```

### ruff - Fast Formatter & Linter
```bash
# Format code
ruff format .

# Lint code
ruff check .

# Auto-fix issues
ruff check --fix .
```

### Why uv + ruff?
- **Speed**: Written in Rust, 10-100x faster than pip/black
- **All-in-one**: uv handles packages, venvs, and Python versions
- **Modern**: Replaces pip, virtualenv, pyenv, and more
- **Compatible**: Works with existing requirements.txt

## ☸️ Kubernetes Tools

Kubernetes development uses **krew** (kubectl plugin manager) with **oidc-login** for authentication:

### krew - kubectl Plugin Manager
```bash
# List installed plugins
kubectl krew list

# Search for plugins
kubectl krew search

# Install a plugin
kubectl krew install ctx ns

# Update plugins
kubectl krew upgrade
```

### oidc-login Plugin
The **oidc-login** plugin is automatically installed for OIDC authentication:

```bash
# Use in kubeconfig
kubectl oidc-login setup

# Login interactively
kubectl oidc-login get-token

# Check status
kubectl krew list | grep oidc-login
```

### Configured Tools
- **kubectl** - Kubernetes CLI
- **helm** - Package manager for Kubernetes
- **k9s** - Terminal UI (with Catppuccin theme!)
- **kustomize** - Configuration management
- **krew** - Plugin manager
  - **oidc-login** - OIDC authentication plugin (auto-installed)

### Why krew?
- **Extend kubectl**: Add custom commands and tools
- **Easy management**: Install/update plugins with simple commands
- **Community plugins**: Access to 200+ community plugins
- **Portable**: Plugins work across different Kubernetes clusters

## 📝 Neovim

**Neovim** is configured as the default editor with **Catppuccin Mocha** theme and essential plugins:

### Configuration
- **Plugin Manager**: lazy.nvim (modern, fast)
- **Theme**: catppuccin/nvim (mocha flavour)
- **Syntax Highlighting**: nvim-treesitter
- **Fuzzy Finder**: telescope.nvim
- **Git Integration**: gitsigns.nvim
- **Status Line**: lualine.nvim (with Catppuccin theme)
- **Auto Pairs**: nvim-autopairs
- **Comments**: Comment.nvim
- **Keybinding Help**: which-key.nvim

### Default Aliases
```bash
vim='nvim'   # vim command uses neovim
vi='nvim'    # vi command uses neovim
v='nvim'     # quick shortcut
```

### Environment Variable
```bash
EDITOR=nvim  # Default editor for git, etc.
```

### Key Bindings (Space as Leader)
```
<Space>ff - Find files
<Space>fg - Live grep (search in files)
<Space>fb - Find buffers
<Space>e  - File explorer
<C-s>     - Save file
<C-hjkl>  - Navigate between windows
```

### First Launch
On first launch, neovim will:
1. Auto-install lazy.nvim plugin manager
2. Install all plugins (including Catppuccin theme)
3. Install Treesitter parsers for syntax highlighting
4. Set up the complete environment

Just run `nvim` and wait for the initial setup to complete!

### Why Neovim?
- **Modern**: Active development, Lua configuration
- **Fast**: Faster than traditional vim
- **Extensible**: Rich plugin ecosystem
- **LSP Support**: Built-in language server protocol
- **Consistent Theme**: Matches your terminal and tools

**Note:** Node.js is intentionally not included. Use devcontainers for Node projects.

## 🔗 Resources

- [eza](https://github.com/eza-community/eza) - Modern ls replacement
- [bat](https://github.com/sharkdp/bat) - Cat clone with wings
- [fd](https://github.com/sharkdp/fd) - Simple, fast alternative to find
- [ripgrep](https://github.com/BurntSushi/ripgrep) - Recursively search directories
- [fzf](https://github.com/junegunn/fzf) - Command-line fuzzy finder
- [zoxide](https://github.com/ajeetdsouza/zoxide) - Smarter cd command
- [uv](https://github.com/astral-sh/uv) - Ultra-fast Python package manager
- [ruff](https://github.com/astral-sh/ruff) - Fast Python linter and formatter
- [krew](https://krew.sigs.k8s.io/) - kubectl plugin manager
- [oidc-login](https://github.com/int128/kubelogin) - kubectl plugin for OIDC authentication

## 📋 Related Files

- `dot_Brewfile.tmpl` - Homebrew packages (macOS)
- `run_once_install-modern-tools.sh.tmpl` - Linux/container installation
- `run_once_after_install-krew-plugins.sh.tmpl` - Krew plugin installation
- `dot_bashrc` - Tool initialization and aliases
- `BASH_VS_ZSH.md` - Why these tools make bash powerful

