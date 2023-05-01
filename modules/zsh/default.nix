{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.zsh;
in {
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ zsh ];   
      file = {
        # Sets .zshrc to my root home directory.
        # TODO: Maybe find a way to move this into the .config/zsh folder?
        ".zshrc".source = ./config/.zshrc;
        # Sets the config files for the zim plugin manager
        "zim" = {
          source = ./config/zim;
          target = ".config/zsh/zim";
          recursive = true;
        };
      };
    };
  };

  # Can be used if you want to keep the config within nix. 
  # I prefer doing as above and allowing the config to be a separate dedicated file.
  # Provides more freedom
/*
    programs.zsh = {
      dotDir = ".config/zsh";
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
  */
}
