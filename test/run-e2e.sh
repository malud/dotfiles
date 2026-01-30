#!/usr/bin/env bash
# run-e2e.sh - End-to-end test runner for chezmoi dotfiles
#
# This script:
# 1. Creates chezmoi config with test data (skips interactive prompts)
# 2. Runs chezmoi init --source=. --apply
# 3. Sources bashrc
# 4. Runs verify-tools.sh
#
# Usage: ./test/run-e2e.sh [source_dir]
#   source_dir: Path to chezmoi source (default: current directory)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${1:-$(pwd)}"

echo "=== E2E Test Runner ==="
echo "Source directory: $SOURCE_DIR"
echo "Home directory: $HOME"
echo ""

# Ensure we're running as a non-root user
if [[ "$(id -u)" == "0" ]]; then
  echo "ERROR: This script should not be run as root"
  echo "Create a test user and run as that user instead"
  exit 1
fi

# Create chezmoi config directory
CONFIG_DIR="$HOME/.config/chezmoi"
mkdir -p "$CONFIG_DIR"

# Create chezmoi config with test data to skip interactive prompts
echo "Creating chezmoi config with test data..."
cat > "$CONFIG_DIR/chezmoi.toml" << 'EOF'
[data]
    name = "E2E Test User"
    email = "e2e-test@example.com"
    signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKeyForE2ETesting"
EOF

echo "Config created at $CONFIG_DIR/chezmoi.toml"
echo ""

# Run chezmoi init and apply
echo "Running chezmoi init --source=$SOURCE_DIR --apply..."
chezmoi init --source="$SOURCE_DIR" --apply --verbose

echo ""
echo "Chezmoi apply completed"
echo ""

# Source bashrc to get the environment
echo "Sourcing ~/.bashrc..."
# shellcheck source=/dev/null
source "$HOME/.bashrc" || true

echo ""

# Run verification
echo "Running tool verification..."
"$SCRIPT_DIR/verify-tools.sh"
