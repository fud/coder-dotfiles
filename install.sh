#!/bin/bash

# Install script for Nix in coder environment
# Similar to GitHub Codespaces dotfiles setup
# Only installs if Nix is not already present

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Checking if Nix is already installed..."

if command -v nix >/dev/null 2>&1 && nix --version >/dev/null 2>&1; then
    echo "Nix is already installed:"
    nix --version
    echo "Skipping installation."
    exit 0
fi

echo "Downloading Determinate Systems Nix installer..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install linux --init none --determinate --no-confirm

sudo chown -R vscode:vscode /nix

echo "Nix installation complete."

echo "Installing flake configuration..."
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

cd "$SCRIPT_DIR"
nix profile add .
echo "Flake configuration installed."

echo "Setting up oh-my-zsh integration..."
nix run .#setup-nix-zsh
echo "oh-my-zsh setup complete."
