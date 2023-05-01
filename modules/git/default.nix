{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.git;
in {
  options.modules.git = { enable = mkEnableOption "git"; };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "m-macdonald";
      userEmail = "";
      extraConfig = {
        init = { defaultBranch = "main"; };
      };
    };
  };
}
