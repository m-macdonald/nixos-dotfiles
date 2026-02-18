{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.dev;
in {
  options.modules.dev = {
    enable = mkEnableOption "packages used in development";
  };

  config = mkIf cfg.enable {
    home.packages = [
      # Dev
      dbeaver-bin
      unstable.obsidian
    ];
  };
}
