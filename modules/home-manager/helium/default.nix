{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.helium;
in {
  options.modules.helium.enable = lib.mkEnableOption "Helium browser";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.helium.packages.${pkgs.system}.default
    ];
  };
}
