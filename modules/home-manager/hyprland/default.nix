{ lib, config, pkgs, inputs, ... }: 
with lib;
let cfg = config.modules.hyprland;
  swww-init = pkgs.writeShellScriptBin "swww-init" ''
    #! /usr/bin/env bash
    files=(/mnt/nas/media/images/pixiv/*)

    random_background=''${files[RANDOM % ''${#files[@]}]}

    if ! ps -ef | grep -v grep | grep -q "swww-daemon"; then
      swww init
    fi
    echo ''$random_background
    swww img "$random_background"
  '';
in {
  options.modules.hyprland = { enable = mkEnableOption "hyprland"; };
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default.override {
        enableXWayland = true;
        enableNvidiaPatches = true;
      };
      systemdIntegration = true;
      extraConfig = builtins.readFile ./config/hyprland.conf;
    };
    home = {
      packages = with pkgs; [
        swww
        eww-wayland
        swww-init
      ];
    };
  };
}
