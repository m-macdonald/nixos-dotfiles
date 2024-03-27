{ config, pkgs, lib, ... }:
{

	imports = [
		../../modules/nixos
	];
	
	modules = {
		plasmaBigScreen.enable = true;
	};

	environment.systemPackages = with pkgs; [ neovim git ];

	services.openssh = {
		enable = true;
		settings = {
			PasswordAuthentication = true;
		};
	};

        networking.networkmanager.enable = true;

	hardware.enableRedistributableFirmware = true;

	system.stateVersion = "23.11";
}
