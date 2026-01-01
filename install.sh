#!/usr/bin/env bash
echo ""
echo "  4. Restart your shell"
echo "  3. Apply dotfiles:      chezmoi apply -v"
echo "  2. Preview changes:     chezmoi diff"
echo "  1. Initialize dotfiles: chezmoi init https://github.com/malud/dotfiles.git"
echo "Next steps:"
echo ""
echo "✨ Setup complete!"
echo ""

install_fonts
install_starship
install_chezmoi

}
  fi
    echo "ℹ️  Install a Nerd Font manually: https://www.nerdfonts.com/"
  else
    fi
      echo "⚠️  Homebrew not found. Install fonts manually."
    else
      brew install --cask font-sauce-code-pro-nerd-font 2>/dev/null || echo "⚠️  Font may already be installed"
      brew tap homebrew/cask-fonts 2>/dev/null || true
      echo "📦 Installing SauceCodePro Nerd Font..."
    if command -v brew &>/dev/null; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
install_fonts() {

}
  fi
    echo "   Install manually: https://starship.rs/guide/#-installation"
    echo "⚠️  curl not found. Skipping starship installation."
  else
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
  if command -v curl &>/dev/null; then
  echo "📦 Installing starship..."

  fi
    return
    echo "✓ starship already installed"
  if command -v starship &>/dev/null; then
install_starship() {

}
  echo "✓ chezmoi installed"
  fi
    exit 1
    echo "❌ Neither curl nor wget found. Please install one and try again."
  else
    sh -c "$(wget -qO- get.chezmoi.io)" -- -b "${HOME}/.local/bin"
  elif command -v wget &>/dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${HOME}/.local/bin"
  if command -v curl &>/dev/null; then
  echo "📦 Installing chezmoi..."

  fi
    return
    echo "✓ chezmoi already installed"
  if command -v chezmoi &>/dev/null; then
install_chezmoi() {

echo "🚀 Setting up dotfiles..."

STARSHIP_BIN="/usr/local/bin/starship"
CHEZMOI_BIN="${HOME}/.local/bin/chezmoi"

set -euo pipefail

