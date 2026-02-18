{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.kodi;
in {
  options.modules.kodi = {
    enable = mkEnableOption "kodi";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager = {
        kodi = {
          enable = true;
          package = pkgs.kodi-gbm.withPackages (p: [
            p.jellyfin
          ]);
        };
      };
      displayManager = {
        autoLogin = {
          enable = true;
          user = "kodi";
        };
        lightdm.greeter.enable = false;
      };
    };

    users.extraUsers.kodi.isNormalUser = true;
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [5021];
    };
  };
}
