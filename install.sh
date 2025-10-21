#!/bin/bash

# Install script for Nix in coder environment
# Similar to GitHub Codespaces dotfiles setup
# Only installs if Nix is not already present

set -e

echo "Checking if Nix is already installed..."

if command -v nix >/dev/null 2>&1 && nix --version >/dev/null 2>&1; then
    echo "Nix is already installed:"
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

# single user mode, so need to chown the nix dir
sudo chown -R vscode:vscode /nix

echo "🎉 Setup complete!"

echo "Installing flake configuration"
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
nix profile add .
echo "Flake installed!"
