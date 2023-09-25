{ config, lib, pkgs, ... }: 
with lib;
let 
  cfg = config.modules.bluetooth;
in {
  options.modules.bluetooth = {
    enable = mkOption {
      description = "Enable bluetooth functionality";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
  };
}
