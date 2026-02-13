{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.nvim;
in {
  options.modules.nvim = {
    enable = mkOption {
      default = false;
      description = "Enable the nvim text editor";
      type = types.bool;
    };
    makeDefaultEditor = mkOption {
      default = false;
      description = "Set nvim to be the default text editor";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
    };

    home.sessionVariables = mkIf cfg.makeDefaultEditor {
      EDITOR = "nvim";
    };
  };
}
