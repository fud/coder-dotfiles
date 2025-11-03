{
  description = "Coder configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
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
      in
      {
        packages = {
          default = pkgs.buildEnv {
            name = "coder-tools";
            paths = [ pkgs.ripgrep pkgs.btop ];
          };
          setup-nix-zsh = setupScript;
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            ripgrep
            btop
          ];
        };
      });
}