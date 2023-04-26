{ pkgs, lib, config, inputs, ... }: 
with lib; let
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
    {wayland.windowManager.hyprland = {
      enable = true;
      nvidiaPatches = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };}
  ];


}
