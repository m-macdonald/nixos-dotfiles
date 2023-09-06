{  config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.modules.nvidia;
in
{
  options.modules.nvidia = {
    enable = mkOption {
      description = "Enable Nvidia drivers";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];

    environment = {
      variables = {
       WLR_BACKEND = "vulkan";
        WLR_RENDERER = "vulkan";
      };
      systemPackages = with pkgs; [
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
      ];
    };

    hardware = {
      opengl = {
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
        ];
      };
      nvidia = {
        open = true;
        powerManagement.enable = true;
        modesetting.enable = true;
      };
    };
  };
}
