{  config, lib, pkgs, ... }:
with lib;
let 
    cfg = config.modules.plasmaBigScreen;
in
{
    options.modules.plasmaBigScreen = {
        enable = mkEnableOption "Enable Plasma Big Screen";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs.libsForQt5; [
            plasma-bigscreen
        ];

        services.xserver = {
            enable = true;
	    layout = "us";
	    autorun = true;
	    exportConfiguration = true;
	    displayManager = {
                #defaultSession = "plasmawayland";
                sddm = {
                    enable = true;
#                    wayland.enable = true;
                };
            };
            desktopManager.plasma5.enable = true;
	    videoDrivers = [ "fbdev" ];
        };
    };
}
