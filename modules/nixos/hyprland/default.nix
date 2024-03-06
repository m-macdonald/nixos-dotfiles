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
    nvidia = mkOption {
        description= "Enable hyprland support for NVIDIA GPUs";
        type = types.bool;
        default = false;
    };
  };


  config = mkIf cfg.hyprland.enable { 
   programs.hyprland = {
     enable = true;
   };

   # environment.sessionVariables = {
   #   NIXOS_OZONE_WL = "1";
   #   WLR_NO_HARDWARE_CURSORS = "1";
   # };
  };
}
