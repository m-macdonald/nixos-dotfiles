{ config, pkgs, inputs, ... }:
{
  imports = [
    ./bluetooth.nix
    ./fonts.nix
    ./nix.nix
    ./shells.nix
  ];

  environment.defaultPackages = [ ];
  services.xserver.desktopManager.xterm.enable = false;

  nix = {
    extraOptions = "
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    ";
  };

  hardware.pulseaudio.enable = false;

  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
