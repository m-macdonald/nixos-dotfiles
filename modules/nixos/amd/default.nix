{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.modules.amd;
in
{   
    options.modules.amd = {
        enable = mkEnableOption "Enable AMD drivers"; 
    };

    config = mkIf cfg.enable {
        boot.initrd.kernelModules = [ "amdgpu" ];
        services.xserver.videoDrivers = [ "amdgpu" ];
    };
}
