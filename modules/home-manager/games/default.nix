{ config, lib, pkgs, ... }:
with lib;
let
cfg = config.modules.games;
in {
    options.modules.games = { enable = mkEnableOption "games"; };

    config = mkIf cfg.enable {
        home.packages = with pkgs; [
            steam
            bottles
# Fixes some issues with games running on wayland/Hyprland
            gamescope
            gamemode
            
            xivlauncher
    	    discord
        ];
    };
}
