{ config, pkgs, lib, ... }:
with lib;
let 
cfg = config.modules.kodi;
in {
	options.modules.kodi = {
		enable = mkEnableOption "kodi";
	};

	config = mkIf cfg.enable {
		programs.kodi = {
			enable = false;
			package = pkgs.kodi.withPackages (p: [
					p.jellyfin
					p.youtube
					p.netflix
					p.upnext
			]);


			settings = {
				general = {
# disables add on updates. Nix should be handling them
					addonupdates = "2";
				};
				local = {
					country = "United States";
					timezonecountry = "United States";
					timezone = "America/New_York";
					subtitlelanguage = "default";
				};
				videoplayer.autoplaynextitem = "1,2";
			};
		};
	};
}
