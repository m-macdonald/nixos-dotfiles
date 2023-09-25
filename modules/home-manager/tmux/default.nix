{  lib, config, pkgs, inputs, ... }:
with lib;
let cfg = config.modules.tmux;
in {
  options.modules.tmux = {
    enable = mkOption {
      description = "Enable tmux";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      historyLimit = 100000;
    };
  };
}
