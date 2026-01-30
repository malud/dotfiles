# E2E Testing

End-to-end tests for the chezmoi dotfiles configuration.

## Running Tests Locally

### Quick Test (in a container)

```bash
# Using Docker
docker run --rm -it -v "$(pwd):/workspace" ubuntu:22.04 bash -c "
  apt-get update && apt-get install -y git curl sudo
  sh -c '\$(curl -fsLS get.chezmoi.io)' -- -b /usr/local/bin
  useradd -m -s /bin/bash testuser
  cp -r /workspace /home/testuser/dotfiles
  chown -R testuser:testuser /home/testuser/dotfiles
  su - testuser -c 'cd /home/testuser/dotfiles && ./test/run-e2e.sh /home/testuser/dotfiles'
"
```

### Manual Test

```bash
# Create chezmoi config to skip prompts
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[data]
    name = "Test User"
    email = "test@example.com"
    signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
EOF

# Run chezmoi
chezmoi init --source=. --apply

# Verify tools
./test/verify-tools.sh
```

## Test Scripts

### verify-tools.sh

Verifies that expected tools are installed and configuration files exist:

- **Package manager tools**: bat, fd, rg, fzf, curl, wget, git, jq
- **GitHub release tools**: nvim, eza, starship, gping, trip
- **Kubernetes tools**: kubectl, kustomize, k9s
- **Config files**: ~/.bashrc, ~/.gitconfig, starship.toml, nvim config

### run-e2e.sh

Main test runner that:
1. Creates chezmoi config with test data (skips interactive prompts)
2. Runs `chezmoi init --source=. --apply`
3. Sources bashrc
4. Runs verify-tools.sh

## GitHub Actions

The workflow (`.github/workflows/e2e-test.yml`) runs tests on:
- Ubuntu (devcontainer base image)
- Ubuntu 22.04
- Debian Bookworm

Tests run automatically on push and pull requests to the main branch.

## Extending the Test Matrix

To add a new distribution:

1. Edit `.github/workflows/e2e-test.yml`
2. Add a new entry to the matrix:

```yaml
matrix:
  include:
    # ... existing entries ...
    - name: Fedora 39
      image: fedora:39
```

3. If the distro uses a different package manager, update the prerequisites step:

```yaml
- name: Install prerequisites
  run: |
    if command -v apt-get &>/dev/null; then
      apt-get update && apt-get install -y git curl sudo
    elif command -v dnf &>/dev/null; then
      dnf install -y git curl sudo
    fi
```

## Adding New Tool Checks

Edit `test/verify-tools.sh` and add checks using the helper functions:

```bash
# Check a command exists and can show version
check_tool mytool

# Check a file exists
check_file "$HOME/.config/mytool/config.yaml" "mytool config"

# Check a directory exists
check_dir "$HOME/.config/mytool" "mytool config directory"

# Check PATH includes a directory
check_path "$HOME/.mytool/bin" "mytool bin in PATH"
```
