{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.localsend;
in {
  options.modules.localsend = {
    enable = lib.mkEnableOption "localsend";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      localsend
    ];
  };
}
