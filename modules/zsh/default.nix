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
      };
      history = {
        ignoreDups = true;
      };
      initExtra = ''
        source '${pkgs.gitstatus}/'
      '';
      # Aliases for directories
      # cd ~dots
      dirHashes = {
        dots = "$HOME/.dotfiles";
        projects = "$HOME/Documents/projects";
      };
      plugins = with pkgs; [
        { 
          name = "gitstatus";
          file = "gitstatus.prompt.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "romkatv";
            repo = "gitstatus";
            rev = "v1.5.4";
            sha256 = "sha256-mVfB3HWjvk4X8bmLEC/U8SKBRytTh/gjjuReqzN5qTk=";
          };
        }
      ];
    };
  };
}
