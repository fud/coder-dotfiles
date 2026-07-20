#!/usr/bin/env bash
set -euo pipefail

if ! command -v nix-daemon >/dev/null 2>&1; then
  exit 0
fi

if pgrep -x nix-daemon >/dev/null 2>&1; then
  exit 0
fi

sudo nohup "$(command -v nix-daemon)" >/tmp/nix-daemon.log 2>&1 &
