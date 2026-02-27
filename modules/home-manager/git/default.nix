{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.git;
in {
  options.modules.git = {enable = mkEnableOption "git";};

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      settings = {
        user = {
          name = "m-macdonald";
          email = "37754975+m-macdonald@users.noreply.github.com";
        };
        init = {defaultBranch = "main";};
        credential.helper = "libsecret";
      };
    };
  };
}
