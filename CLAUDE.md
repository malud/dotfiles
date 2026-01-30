# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Portable bash-based dotfiles managed with **chezmoi**, themed with **Catppuccin Mocha**. Dual-platform support: macOS (Homebrew) and Linux (Ansible).

## Chezmoi Commands

```bash
chezmoi diff              # Preview changes before applying
chezmoi apply -v          # Apply dotfiles to home directory
chezmoi update -v         # Pull latest and apply
chezmoi edit <file>       # Edit source file (e.g., chezmoi edit ~/.bashrc)
chezmoi cd                # Navigate to source directory
```

## File Naming Conventions

Chezmoi uses special prefixes for source files:
- `dot_` → `.` (e.g., `dot_bashrc` → `~/.bashrc`)
- `.tmpl` suffix → Template file processed with Go text/template
- `run_once_*` → Scripts that run once per machine
- `run_once_before_*` → Run before applying files
- `run_once_after_*` → Run after applying files
- `run_onchange_*` → Run when content hash changes

## Architecture

**Platform-specific installation:**
- **macOS**: `run_once_before_install-homebrew.sh.tmpl` installs Homebrew, `run_once_install-packages.sh.tmpl` runs `brew bundle`, `dot_Brewfile.tmpl` defines packages
- **Linux**: `run_once_before_install-uv.sh.tmpl` installs uv, `run_onchange_ansible-playbook.sh.tmpl` runs Ansible via `uvx --from ansible` (keeps Python deps isolated from system)

**Configuration hierarchy:**
- `.chezmoi.toml.tmpl` → Prompts for user config (name, email, signing key) on init
- `.chezmoiignore` → OS-conditional file exclusions
- `dot_bashrc` → Main shell config, sources `~/.bashrc.local` for local overrides

**Templating:** Files ending in `.tmpl` use chezmoi's template syntax. Common patterns:
```
{{ if eq .chezmoi.os "darwin" }}...{{ end }}
{{ if eq .chezmoi.os "linux" }}...{{ end }}
{{ .name }}, {{ .email }}, {{ .signingkey }}
```

## Devcontainer / DevPod Usage

This repository supports development inside devcontainers (VS Code Dev Containers, DevPod, GitHub Codespaces).

**How it works:**
1. Devcontainer uses `ghcr.io/rio/features/chezmoi` feature to install chezmoi
2. On Linux containers, chezmoi triggers the Ansible installation path
3. A named volume (`devcontainer-home`) persists `/home/vscode` across rebuilds

**DevPod configuration:**
- `SSH_INJECT_GIT_CREDENTIALS=false` prevents host `.gitconfig` syncing
- Allows different git identities per project (configured via chezmoi prompts)
- SSH authentication uses agent forwarding instead

**SSH agent forwarding (Docker Desktop on macOS):**
- Docker Desktop mounts host SSH agent at `/run/host-services/ssh-auth.sock`
- The devcontainer.json mounts this socket and sets `SSH_AUTH_SOCK`
- 1Password SSH keys are automatically available inside containers

## Key Files

| Source File | Destination | Purpose |
|-------------|-------------|---------|
| `dot_bashrc` | `~/.bashrc` | Shell config, aliases, functions |
| `dot_gitconfig.tmpl` | `~/.gitconfig` | Git config with SSH signing (1Password on macOS) |
| `dot_Brewfile.tmpl` | `~/.Brewfile` | Homebrew packages (macOS) |
| `dot_config/ansible/playbook.yml` | `~/.config/ansible/playbook.yml` | Linux package installation |
| `dot_config/nvim/init.lua` | `~/.config/nvim/init.lua` | Neovim config (lazy.nvim) |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Prompt configuration |

## Code Style

- **Comments**: Only for non-obvious logic or special knowledge (e.g., why Debian names bat as batcat, ICMP capability requirements). Avoid comments that merely describe what code does.

## Theme

Catppuccin Mocha is applied consistently across: Ghostty terminal, Starship prompt, Neovim, k9s, and fzf. Color values are documented in `CATPPUCCIN.md`.

## Modern CLI Tool Aliases

When available, these replacements are used (defined in `dot_bashrc`):
- `ls` → `eza`, `cat` → `bat`, `find` → `fd`, `grep` → `rg`
- `z`/`zi` → zoxide (smart directory jumping)
- `v`/`vim`/`vi` → neovim
