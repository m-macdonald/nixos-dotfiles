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
            desktopManager.plasma6.enable = true;
            displayManager = {
                enable = true;
                sddm.enable = true;
            };

			xrdp = {
				enable = true;
                # Had to disable compositing to get rdp working again after move to Plasma6
				defaultWindowManager = "${pkgs.writeShellScript "start-plasma-xrdp" ''
                    export KWIN_COMPOSE=N
                    exec startplasma-x11
                ''}";
				openFirewall = true;
			};
		};
	};
}
