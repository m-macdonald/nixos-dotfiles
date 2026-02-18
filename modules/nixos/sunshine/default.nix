{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.sunshine;
in {
  options.modules.sunshine = {
    enable = mkEnableOption "Sunshine game streaming";
  };

  config = mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
