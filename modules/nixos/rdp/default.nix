{ config, lib, ... }:
with lib;
let 
	cfg = config.modules.rdp;
in {
	options.modules.rdp = {
		enable = mkEnableOption "rdp";
	};

	config = mkIf cfg.enable {
		services = {
            desktopManager.plasma6.enable = true;
            displayManager = {
                enable = true;
                sddm.enable = true;
            };

			xrdp = {
				enable = true;
				defaultWindowManager = "startplasma-x11";
                openFirewall = true;
			};
		};
	};
}
