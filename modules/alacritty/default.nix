{ lib, config, pkgs, ... }: 
with lib;
with builtins;
let cfg = config.modules.alacritty;
in {
  options.modules.alacritty = { enable = mkEnableOption "alacritty"; };

  config = mkIf cfg.enable {
    home = { 
      sessionVariables = {
        TERM = "alacritty";
      };
    };
    programs.alacritty = {
      enable = true;
      settings = {
        window.opacity = 0.8;
      };
    };
  };
}
