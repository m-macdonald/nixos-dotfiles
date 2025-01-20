{ config, lib, pkgs, ... }:
with lib;
let 
	cfg = config.modules.rdp;
in {
	options.modules.rdp = {
		enable = mkEnableOption "rdp";
	};

	config = mkIf cfg.enable {
		services = {
			xserver = {
				enable = true;
				displayManager.sddm.enable = true;
				desktopManager.plasma5.enable = true;
			};

			xrdp = {
				enable = true;
				defaultWindowManager = "startplasma-x11";
				openFirewall = true;
			};
		};
	};
}
