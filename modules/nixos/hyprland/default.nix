{  config, lib, inputs, pkgs, ... }: 
with lib;
let
  cfg = config.modules;
in
{
  options.modules.hyprland = {
    enable = mkOption {
      description = "Enable the Hyprland window manager";
      type = types.bool;
      default = false;
    }; 
  };


  config = mkIf cfg.hyprland.enable { 
   nix.settings = { 
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    environment.variables = {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      # TODO: This is a fix for nvidia GPUs. Would like to find a way to conditionally include it if nvidia module is enabled
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    services.xserver.displayManager.sessionPackages = [ inputs.hyprland.packages.${pkgs.system}.default ];

    xdg = {
      portal = {
        enable = true;
        extraPortals = [
          (inputs.xdph.packages.${pkgs.system}.xdg-desktop-portal-hyprland.override {
            hyprland-share-picker = inputs.xdph.packages.${pkgs.system}.hyprland-share-picker.override {hyprland = inputs.hyprland.packages.${pkgs.system}.default.override { enableNvidiaPatches = cfg.nvidia.enable; enableXWayland = true; };};
          })
        ];
      };
    };
  };
}
