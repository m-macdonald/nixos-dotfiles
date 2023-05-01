{ lib, config, pkgs, ... }: 
with lib;
with builtins;
let cfg = config.modules.alacritty;
in {
  options.modules.alacritty = { enable = mkEnableOption "alacritty"; };

  config = mkIf cfg.enable {
    home = { 
      sessionVariables = {
        TERM = "${pkgs.alacritty}/bin/alacritty";
      };
      packages = with pkgs; [
        alacritty
      ];
    };
  };
}
