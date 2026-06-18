# Coder Dot Files

# Update the flake.lock file

In github workspaces

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |   sh -s -- install linux --init none --determinate --no-confirm

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

fud ➜ /workspaces/coder-dotfiles (main) $ sudo $(which nix-daemon) &
[1] 17147
@fud ➜ /workspaces/coder-dotfiles (main) $ 
@fud ➜ /workspaces/coder-dotfiles (main) $ nix flake update
accepted connection from pid 17268, user codespace
warning: updating lock file "/workspaces/coder-dotfiles/flake.lock":
• Updated input 'nixpkgs':
    'github:NixOS/nixpkgs/2d293cb' (2025-11-30)
  → 'github:NixOS/nixpkgs/567a49d' (2026-06-16)
```