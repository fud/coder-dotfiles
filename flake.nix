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

        # Create oh-my-zsh aliases for editor commands
        aliasesZshConfig = pkgs.writeText "aliases.zsh" ''
          alias vim="nvim"
          alias vi="nvim"
          alias less="bat"
          alias cat="bat"

          claude() {
            local branch
            branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo -n unknown)"

            if command -v tmux >/dev/null 2>&1; then
              tmux rename-window "claude ($branch)" 2>/dev/null || true
            fi

            command claude "$@"
          }
        '';
        
        # Setup script that creates/updates the oh-my-zsh config
        setupScript = pkgs.writeShellScriptBin "setup-nix-zsh" ''
          mkdir -p "$HOME/.oh-my-zsh/custom"

          update_managed_block() {
            local target="$1"
            local source="$2"
            local name="$3"
            local start="# >>> coder-dotfiles-managed:start >>>"
            local end="# <<< coder-dotfiles-managed:end <<<"
            local tmp
            tmp="$(mktemp)"

            if [ ! -f "$target" ]; then
              touch "$target"
            fi

            awk -v s="$start" -v e="$end" '
              $0 == s { in_block=1; next }
              $0 == e { in_block=0; next }
              !in_block { print }
            ' "$target" > "$tmp"

            {
              cat "$tmp"
              [ -s "$tmp" ] && [ "$(tail -c1 "$tmp" 2>/dev/null || true)" != "" ] && printf "\n"
              printf "%s\n" "$start"
              cat "$source"
              printf "%s\n" "$end"
            } > "$target"

            rm -f "$tmp"
            echo "Updated managed $name configuration"
          }

          update_managed_block "$HOME/.oh-my-zsh/custom/nix.sh" ${nixZshConfig} "Nix"
          update_managed_block "$HOME/.oh-my-zsh/custom/aliases.zsh" ${aliasesZshConfig} "aliases"
        '';
        
      in
      {
        packages = {
          default = pkgs.buildEnv {
            name = "coder-tools";
            paths = with pkgs; [ 
              bat
              btop 
              claude-code
              delta
              neovim
              pgcli
              ripgrep 
            ];
          };
          setup-nix-zsh = setupScript;
        };
      });
}