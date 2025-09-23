#!/bin/bash

# Install script for Nix in coder environment
# Similar to GitHub Codespaces dotfiles setup
# Only installs if Nix is not already present

set -e  # Exit on any error

echo "🔍 Checking if Nix is already installed..."

# Check if nix command exists and is functional
if command -v nix >/dev/null 2>&1 && nix --version >/dev/null 2>&1; then
    echo "✅ Nix is already installed:"
    nix --version
    echo "Skipping installation."
    exit 0
fi

# Download the Determinate Systems Nix installer
echo "Downloading Determinate Systems Nix installer..."
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install linux --init none --determinate --no-confirm

# installing it to omyzsh config
if [ ! -f "$HOME/.oh-my-zsh/custom/nix.sh" ]; then
    echo "source ~/.nix-profile/etc/profile.d/nix.sh" > ~/.oh-my-zsh/custom/nix.sh
fi
echo "🎉 Setup complete!"