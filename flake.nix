{
  description = "Coder configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };

        # Create oh-my-zsh nix configuration
        nixZshConfig = pkgs.writeText "nix.sh" ''
          source ~/.nix-profile/etc/profile.d/nix.sh
        '';
        
        # Setup script that creates the oh-my-zsh config
        setupScript = pkgs.writeShellScriptBin "setup-nix-zsh" ''
          mkdir -p "$HOME/.oh-my-zsh/custom"
          if [ ! -f "$HOME/.oh-my-zsh/custom/nix.sh" ]; then
            cp ${nixZshConfig} "$HOME/.oh-my-zsh/custom/nix.sh"
            echo "Created oh-my-zsh Nix configuration"
          else
            echo "oh-my-zsh Nix configuration already exists"
          fi
        '';

        environment.shellAliases = {
          vim = "nvim";
          vi = "nvim";
        };
        
      in
      {
        packages = {
          default = pkgs.buildEnv {
            name = "coder-tools";
            paths = with pkgs; [ 
              ripgrep 
              btop 
              pgcli
              neovim
              claude-code
            ];
          };
          setup-nix-zsh = setupScript;
        };
      });
}