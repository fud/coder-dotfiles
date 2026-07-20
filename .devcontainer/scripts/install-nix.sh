#!/usr/bin/env bash
set -euo pipefail

if command -v nix >/dev/null 2>&1; then
  echo "nix is already installed"
  exit 0
fi

curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
  | sh -s -- install linux --init none --determinate --no-confirm

if ! grep -q "nix-daemon.sh" "$HOME/.bashrc"; then
  echo ". /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" >> "$HOME/.bashrc"
fi

# shellcheck disable=SC1091
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

if ! pgrep -x nix-daemon >/dev/null 2>&1; then
  sudo nohup "$(command -v nix-daemon)" >/tmp/nix-daemon.log 2>&1 &
fi

echo "nix bootstrap complete"
nix --version || true
