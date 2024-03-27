{ config, lib, pkgs, nixos-hardware, modulesPath, ... }:
with lib;
{
#	modules = [
#		nixos-hardware.nixosModules.raspberry-pi-4
#	];

	boot = {
		kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
		initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage"  ];
		loader = {
			grub.enable = false;
			generic-extlinux-compatible.enable = true;
		};
	};

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-label/NIXOS_SD";
			fsType = "ext4";
			options = [ "noatime" ];
		};
	};

	networking = {
		hostName = "media-center";
		wireless = {
			enable = true;
			interfaces = [ "wlan0" ];
		};
	};
}
