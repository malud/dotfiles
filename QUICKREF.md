# Quick Reference

## Chezmoi Commands

```bash
chezmoi init https://github.com/malud/dotfiles.git  # Clone dotfiles
chezmoi diff                                         # Preview changes
chezmoi apply -v                                     # Apply dotfiles
chezmoi update -v                                    # Pull and apply updates
chezmoi edit ~/.bashrc                               # Edit source file
chezmoi add ~/.config/newapp/config                  # Add new file to dotfiles
chezmoi cd                                           # Go to source directory
chezmoi status                                       # Show changes
```

## Homebrew Commands (macOS)

```bash
brew install <package>              # Install a package
brew uninstall <package>            # Remove a package
brew update                         # Update Homebrew
brew upgrade                        # Upgrade all packages
brew list                           # List installed formulae
brew list --cask                    # List installed casks
brew bundle --file=~/.Brewfile      # Install from Brewfile
brew search <term>                  # Search for packages
brew info <package>                 # Show package info
brew cleanup                        # Remove old versions
```

```

## Remote Setup (One-liner)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply malud
curl -sS https://starship.rs/install.sh | sh
```

## Local Customization

Create `~/.bashrc.local` for machine-specific configs that won't sync.

## Updating Dotfiles

```bash
cd ~/.local/share/chezmoi
git add .
git commit -m "Update configs"
git push
```

Then on other machines:
```bash
chezmoi update -v
```

