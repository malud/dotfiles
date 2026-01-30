# Dotfiles task runner

# Default recipe - show available commands
default:
    @just --list

# Run E2E tests in a container (use --interactive for local testing)
test image="ubuntu:22.04" *args="":
    docker run --rm {{args}} -v "$(pwd):/workspace" {{image}} sh -c ' \
        if command -v apt-get >/dev/null; then \
            apt-get update && apt-get install -y git curl sudo bash; \
        elif command -v dnf >/dev/null; then \
            dnf install -y git curl sudo bash; \
        elif command -v apk >/dev/null; then \
            apk add --no-cache git curl sudo bash shadow; \
        fi && \
        curl -fsLS get.chezmoi.io | sh -s -- -b /usr/local/bin && \
        useradd -m -s /bin/bash testuser && \
        echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
        cp -r /workspace /home/testuser/dotfiles && \
        chown -R testuser:testuser /home/testuser/dotfiles && \
        su - testuser -c "export PATH=/usr/local/bin:\$PATH && cd /home/testuser/dotfiles && ./test/run-e2e.sh /home/testuser/dotfiles"'

# Run E2E tests interactively (for local development)
test-interactive image="ubuntu:22.04":
    just test {{image}} "-it"

# Run E2E tests on all supported images
test-all:
    just test "mcr.microsoft.com/vscode/devcontainers/base:ubuntu"
    just test "ubuntu:22.04"
    just test "debian:bookworm"
    just test "fedora:41"
    just test "alpine:3.21"

# Verify tools (runs on current system)
verify:
    ./test/verify-tools.sh

# Preview chezmoi changes
diff:
    chezmoi diff

# Apply chezmoi changes
apply:
    chezmoi apply -v

# Update from remote and apply
update:
    chezmoi update -v
