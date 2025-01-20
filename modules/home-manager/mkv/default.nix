{ config, pkgs, lib, inputs, ... }:
with lib;
let
	cfg = config.modules.mkv;
	libbluray = pkgs.libbluray.override {
		withAACS = true;
		withBDplus = true;
		/*
		libaacs = pkgs.libaacs;
		libbdplus = pkgs.libbdplus;
		*/
		withJava = true;
	};
	vlc = pkgs.vlc.override { inherit libbluray; };
in {
	options.modules.mkv = {
		enable = mkEnableOption "disk ripping";
	};

	config = mkIf cfg.enable {
		home.packages = with pkgs; [
			mkvtoolnix
			makemkv
			mpv
		] ++ [ vlc ];
	};

/*
	imports = [
		inputs.arion.nixosModules.arion
	];


	options.modules.mkv = {
		enable = mkEnableOption "disk ripping";
	};

	config = mkIf cfg.enable {
		virtualisation.arion = {
			backend = "podman-socket";
			projects.mkv = {
				serviceName = "mkv";
				settings = {
					services = {
						makemkv.service = {
							image = "jlesage/makemkv:v24.12.1";
							volumes = [
								"/data/makemkv/output:/output:rw"	
								"/home/maddux/makemkv/config:/config:rw"
							];
							devices = [
								"/dev/sr0:/dev/sr0"
								"/dev/sg2:/dev/sg2"
							];
							ports = [
								"5800:5800"
							];
						};
					};	
				};
			};
		};
	};
*/
}
