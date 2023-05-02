{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.nvim;
in {
  options.modules.nvim = { enable = mkEnableOption "nvim"; };
  
  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };

    home.file."nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/nvim/config";
      target = ".config/nvim";
      recursive = true;
    };

    # Not a huge fan of this, but these languages/tools are needed for the language servers the Mason plugin tries to install
    # Might try to eventually move these into separate nix shells
    home.packages = with pkgs; [
      go
      rustup
      # Would prefer volta but atm there is no nix package for it. Might look into writing one
      nodenv
      volta
    ];
  };
}
