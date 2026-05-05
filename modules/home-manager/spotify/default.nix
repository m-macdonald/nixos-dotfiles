{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.spotify;
in {
  options.modules.spotify = {
    enable = mkEnableOption "spotify";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];
  };
}
