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

echo "📦 Nix not found. Installing Nix..."

# Create a temporary directory for the installation
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Download the Nix installer
echo "⬇️  Downloading Nix installer..."
curl -L https://nixos.org/nix/install -o "$TEMP_DIR/install-nix.sh"

# Verify the download was successful
if [ ! -f "$TEMP_DIR/install-nix.sh" ]; then
    echo "❌ Failed to download Nix installer"
    exit 1
fi

# Make the installer executable
chmod +x "$TEMP_DIR/install-nix.sh"

# Install Nix in single-user mode (suitable for containers/codespaces)
echo "🚀 Installing Nix (single-user mode)..."
"$TEMP_DIR/install-nix.sh" --no-daemon

# Source the Nix profile to make nix command available in current session
if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    echo "🔧 Sourcing Nix profile..."
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Verify installation
if command -v nix >/dev/null 2>&1; then
    echo "✅ Nix installation successful!"
    nix --version

    # Add some useful information
    echo ""
    echo "📝 To use Nix in new shell sessions, run:"
    echo "   source ~/.nix-profile/etc/profile.d/nix.sh"
    echo ""
    echo "💡 Or add this line to your shell's RC file (~/.bashrc, ~/.zshrc, etc.)"
else
    echo "❌ Nix installation failed - nix command not found"
    exit 1
fi

echo "🎉 Setup complete!"