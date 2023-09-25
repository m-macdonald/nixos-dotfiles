{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.zsh;
in {
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        ls = "ls -a";
        rebuild = "sudo nixos-rebuild switch --flake ~dots/.#\${hostname}";
        rebuild-home = "nix build ~dots/#homeManagerConfigurations.$USER@$(hostname).activationPackage && ~dots/result/activate";
        shell = "fn() { nix-shell ~dots/shells/$1.nix };fn";
      };
      history = {
        ignoreDups = true;
      };
      # Nothing for now, but leaving here so I don't have to find the documentation again.
      initExtra = '' '';
      # Aliases for directories
      # cd ~dots
      dirHashes = {
        dots = "$HOME/.dotfiles";
        projects = "$HOME/Documents/projects";
      };
      plugins = with pkgs; [
        { 
          name = "spaceship";
          file = "spaceship.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "spaceship-prompt";
            repo = "spaceship-prompt";
            rev = "v4.13.5";
            sha256 = "sha256-4yUSTDqUHSW8if84bjXht/iY9U7zR2/agVWKT5f2PKM=";
          };
        }
      ];
    };
  };
}
