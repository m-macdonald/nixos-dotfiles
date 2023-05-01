{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.neovim;
in {
  options.modules.neovim = { enable = mkEnableOption "neovim"; };
  
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    home.file."nvim" = {
      source = file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/neovim/config";
      target = ".config/nvim";
      recursive = true;
    };
  };
}
