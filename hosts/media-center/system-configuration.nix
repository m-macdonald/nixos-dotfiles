{
  config,
  pkgs,
  lib,
  ...
}: {
  modules = {
    podman.enable = true;
    rdp.enable = true;
  };

  environment.systemPackages = with pkgs; [neovim git];
  boot.loader.systemd-boot.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  networking = {
    hostName = "media-center";
  };

  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "23.11";
}
