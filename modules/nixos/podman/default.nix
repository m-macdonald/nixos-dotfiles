{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.podman;
  dockerCfg = config.modules.docker;
in {
  options.modules.podman = {
    enable = mkEnableOption "podman";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.docker-client
    ];

    virtualisation = {
      docker.enable = false;
      podman = {
        enable = true;
        dockerSocket.enable = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
