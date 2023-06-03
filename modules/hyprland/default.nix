{ lib, config, pkgs, inputs, ... }: 
with lib;
let cfg = config.modules.hyprland;
  swww-init = pkgs.writeShellScriptBin "swww-init" ''
    swww init
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
        hidpiXWayland = true;
        nvidiaPatches = true;
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
