{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.modules.amd;
in
{   
    options.modules.amd = {
        enable = mkEnableOption "Enable AMD drivers"; 
    };

    config = mkIf cfg.enable {
        play = {
            amd.enable = true;
            steam = {
                enable = true;
                extraCompatPackages = with pkgs; [
                    proton-ge-bin
                ];
            };
            gamemode.enable = true;
            lutris.enable = true;
        };
    };
}
