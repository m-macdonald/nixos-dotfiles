{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules;
in {
  options.modules.hyprland = {
    enable = mkOption {
      description = "Enable the Hyprland window manager";
      type = types.bool;
      default = false;
    };
    nvidia = mkOption {
      description = "Enable hyprland support for NVIDIA GPUs";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.hyprland.enable {
    programs.hyprland = {
      enable = true;
    };
  };
}
