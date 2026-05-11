{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.modules.steam;
in {
  options.modules.steam.enable = lib.mkEnableOption "Steam";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      protontricks = {
        enable = true;
      };
      extraCompatPackages = with pkgs; [
        # X11 libraries
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver

        # System libraries
        stdenv.cc.cc.lib
        gamemode
        gperftools
        keyutils
        libkrb5
        libpng
        libpulseaudio
        libvorbis
        mangohud
        proton-ge-bin
        inputs.dw-proton.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
