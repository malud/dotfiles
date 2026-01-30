#!/usr/bin/env bash
# verify-tools.sh - Verify tool installations after chezmoi apply
#
# This script checks that expected tools are installed and configuration
# files exist. It outputs a summary of pass/fail counts.

set -euo pipefail

PASS=0
FAIL=0

# Color output (if terminal supports it)
if [[ -t 1 ]]; then
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  YELLOW='\033[0;33m'
  NC='\033[0m' # No Color
else
  GREEN=''
  RED=''
  YELLOW=''
  NC=''
fi

pass() {
  echo -e "${GREEN}✓${NC} $1"
  PASS=$((PASS + 1))
}

fail() {
  echo -e "${RED}✗${NC} $1"
  FAIL=$((FAIL + 1))
}

warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

# Check if a command exists and is executable
check_tool() {
  local tool="$1"

  if command -v "$tool" &>/dev/null; then
    pass "$tool"
  else
    fail "$tool (not found)"
  fi
}

# Check if a file exists
check_file() {
  local file="$1"
  local description="${2:-$file}"

  if [[ -f "$file" ]]; then
    pass "$description"
  else
    fail "$description (not found: $file)"
  fi
}

# Check if a directory exists
check_dir() {
  local dir="$1"
  local description="${2:-$dir}"

  if [[ -d "$dir" ]]; then
    pass "$description"
  else
    fail "$description (not found: $dir)"
  fi
}

# Check if PATH includes a directory
check_path() {
  local dir="$1"
  local description="${2:-$dir in PATH}"

  if [[ ":$PATH:" == *":$dir:"* ]]; then
    pass "$description"
  else
    fail "$description"
  fi
}

echo "=== Tool Verification ==="
echo ""

echo "--- Package Manager Tools ---"
check_tool bat
check_tool fd
check_tool rg
check_tool fzf
check_tool curl
check_tool wget
check_tool git
check_tool jq

echo ""
echo "--- GitHub Release Tools ---"
check_tool nvim
check_tool eza
check_tool starship
check_tool gping
check_tool trip

echo ""
echo "--- Build Tools ---"
check_tool just

echo ""
echo "--- Kubernetes Tools ---"
check_tool kubectl
check_tool kustomize
check_tool k9s

echo ""
echo "--- Configuration Files ---"
check_file "$HOME/.bashrc" "~/.bashrc"
check_file "$HOME/.gitconfig" "~/.gitconfig"
check_file "$HOME/.config/starship.toml" "starship.toml"
check_dir "$HOME/.config/nvim" "nvim config directory"
check_file "$HOME/.config/nvim/init.lua" "nvim init.lua"

echo ""
echo "--- PATH Configuration ---"
check_path "$HOME/.local/bin" "~/.local/bin in PATH"

echo ""
echo "=== Summary ==="
echo -e "Passed: ${GREEN}${PASS}${NC}"
echo -e "Failed: ${RED}${FAIL}${NC}"

if [[ $FAIL -gt 0 ]]; then
  exit 1
fi
