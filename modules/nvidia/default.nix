{ config, pkgs, lib, ... }: 
{
  services.xserver.videoDrivers = ["nvidia"];

  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
  ];

  hardware = {
    nvidia = {
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
#	libvdpau-va-gl
#	vaapiVdpau
      ];
    };
  }; 
}
