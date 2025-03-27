{  config, lib, pkgs, ... }:
with lib;
let 
    cfg = config.modules.plasmaBigScreen;
in
{
    options.modules.plasmaBigScreen = {
        enable = mkEnableOption "Plasma Big Screen";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
        	jellyfin-media-player
	];

        services.xserver = {
            enable = true;
	    layout = "us";
	    #autorun = true;
	    exportConfiguration = true;
	    displayManager = {
#                defaultSession = "plasmawayland";
                sddm = {
                    enable = true;
#                    wayland.enable = true;
                };
            };
            desktopManager.plasma5.bigscreen.enable = true;
        };
    };
}
