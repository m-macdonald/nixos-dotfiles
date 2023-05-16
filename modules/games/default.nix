{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.games;
in {
  options.modules.games = { enable = mkEnableOption "games"; };

  config = mkIf cfg.enable {
    # I know there's a better way of doing this but I want to keep steam as user package, not a system one. 
    # Couldn't find a better way to install as a user package
    home.packages = with pkgs; [
      steam
      # Fixes some issues with games running on wayland/Hyprland
      gamescope
      gamemode
    ];
  };
}
