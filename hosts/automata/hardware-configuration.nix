{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    # TODO: Check this periodically to see if nixos has moved linuxPackages_latest
    # to, or beyond, version 6.16. 6.16 is the first version to have the ntsync module that augments wine and proton performance.
    kernelPackages = pkgs.linuxPackages_6_18;
    kernelModules = ["kvm-amd" "ntsync"];

    initrd = {
      availableKernelModules = [
        "nvme"
        "ahci"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/.swapfile";}
  ];

  networking = {
    networkmanager.enable = false;
    useNetworkd = true;
    useDHCP = false;
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-eth" = {
        matchConfig.Name = "enp13s0";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = false;
        };
        dhcpV4Config = {
          UseDNS = true;
          UseDomains = true;
          UseRoutes = true;
          UseHostname = false;
        };
      };
    };
  };

  services.resolved = {
    enable = true;
    fallbackDns = ["1.1.1.1"];
    extraConfig = ''
      Cache=yes
      ReadEtcHosts=yes
    '';
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
