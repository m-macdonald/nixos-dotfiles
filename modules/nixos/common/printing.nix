{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.printing;
in {
  options.modules.printing = {
    enable = lib.mkEnableOption "printing";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
