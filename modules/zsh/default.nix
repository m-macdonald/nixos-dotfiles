{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.zsh;
in {
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    # Sets .zshrc to my root home directory.
    # TODO: Maybe find a way to move this into the .config/zsh folder?
    home.file.".zshrc".source = ./config/.zshrc;

    # Sets the config files for the zim plugin manager
    home.file."zim" = {
      source = ./config/zim;
      target = ".config/zsh/zim";
      recursive = true;
    };

    # Additional zsh config
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
