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
        extraOptions = ''
              experimental-features = nix-command flakes
              keep-outputs = true
              keep-derivations = true
            '';
    };

    hardware.pulseaudio.enable = false;

    services.pipewire = {
        enable = true;
        alsa.enable = true;
    };
}
