# Coder Dot Files

## Codespaces + Determinate Nix

This repo uses the Determinate Systems installer in [install-nix.sh](.devcontainer/scripts/install-nix.sh) for Codespaces bootstrap:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
  | sh -s -- install linux --init none --determinate --no-confirm
```

Codespaces runs this automatically from [devcontainer.json](.devcontainer/devcontainer.json) via `postCreateCommand`.

## NixOS status

The [NixOS status page](https://status.nixos.org/) shows the current operational status of NixOS infrastructure, including build farm health, cache availability, and service incidents. It is useful when troubleshooting flakes, package availability, or wider Nix ecosystem outages.

## Update flake.lock

Update everything:

```bash
nix flake update
```

Update only `nixpkgs`:

```bash
nix flake lock --update-input nixpkgs
```
