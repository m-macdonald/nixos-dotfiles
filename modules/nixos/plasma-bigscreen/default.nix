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
/*
	environment.systemPackages = with pkgs.libsForQt5; [
            plasma-bigscreen
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
	    videoDrivers = [ "fbdev" ];
        };
    };
*/
/**/

	services.cage = {
	    user = "kodi";
	    program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
	    enable = true;
	};
/*
	systemd.services."cage-tty1".after = [
		"network-online.target"
		"systemd-resolved.service"
	];
*/
	users.extraUsers.kodi.isNormalUser = true;
	hardware.opengl.enable = true;
    };

/**/
}
