{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.zsh;
in {
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    home.file.".zshrc"source = ./config/.zshrc;
    home.file."zim" = {
      source = ./config/zim;
      target = .config/zsh/zim;
      recursive = true;
    };
    programs.zsh = {
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      sessionVariables = {
        EDITOR = "nvim";
      };

      # Aliases for directories
      # cd ~dots
      dirHashes = {
        dots = "$HOME/.dotfiles";
      };
    };
  };
}
