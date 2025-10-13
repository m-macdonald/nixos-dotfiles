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

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa = {
            enable = true;
            support32Bit = true;
        };
        pulse.enable = true;
        wireplumber.enable = true;
        jack.enable = true;
        # lowLatency.enable = true;
    };
}
