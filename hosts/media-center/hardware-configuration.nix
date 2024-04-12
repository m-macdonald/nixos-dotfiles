{ pkgs, ... }:
{
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

	hardware = {
		raspberry-pi."4" = {
			apply-overlays-dtmerge.enable = true;
			fkms-3d.enable = true;
		};
/*		deviceTree = {
			enable = true;
			filter = "*rpi-4-*.dtb";
		};
*/
	};

	console.enable = false;
	environment.systemPackages = with pkgs; [
		libraspberrypi
		raspberrypi-eeprom
	];

}
