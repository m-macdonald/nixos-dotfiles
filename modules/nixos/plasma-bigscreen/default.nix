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
/**/

	services.cage = let
		package = pkgs.kodi-wayland.withPackages (kodiPkgs: [
			kodiPkgs.netflix
			kodiPkgs.jellyfin
			kodiPkgs.youtube
			kodiPkgs.jellycon
			pkgs.embuary
		]);
 	in {
	    user = "kodi";
	    program = "${package}/bin/kodi-standalone";
	    enable = true;
	};
/**/
	systemd.services."cage-tty1".after = [
		"network-online.target"
		"systemd-resolved.service"
	];

	users.extraUsers.kodi.isNormalUser = true;
	hardware.opengl.enable = true;
    };

/**/
/*
	users.extraUsers.kodi.isNormalUser = true;
	systemd.services.kodi = let 
		package = pkgs.kodi-gbm.withPackages (kodiPkgs: [
			kodiPkgs.netflix
			kodiPkgs.jellyfin
			kodiPkgs.youtube
		]);
	in {
		description = "Kodi media center";
		
		wantedBy = ["multi-user.target"];
		after = [
			"network-online.target"
			"sound.target"
			"systemd-user-sessions.service"
		];
		wants = [
			"network-online.target"
		];

		serviceConfig = {
			Type = "simple";
			User = "kodi";
			ExecStart = "${package}/bin/kodi-standalone";
			Restart = "always";
			TimeoutStopSec = "15s";
			TimeoutStopFailureMode = "kill";
		};
	};
   };
   */
}
