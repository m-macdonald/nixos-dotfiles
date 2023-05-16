{ lib, config, pkgs, inputs, ... }: 
with lib;
let cfg = config.modules.hyprland;
in {
  options.modules.hyprland = { enable = mkEnableOption "hyprland"; };
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      nvidiaPatches = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };
  };
}
