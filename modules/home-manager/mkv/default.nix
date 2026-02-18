{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.mkv;
  libbluray = pkgs.libbluray.override {
    withAACS = true;
    withBDplus = true;
    withJava = true;
  };
  vlc = pkgs.vlc.override {inherit libbluray;};
in {
  options.modules.mkv = {
    enable = mkEnableOption "disk ripping";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        mkvtoolnix
        makemkv
        mpv
        # TODO: I don't particularly want Java exposed to my entire user environment, but I'm too lazy to go a different route right now
        jdk17
      ]
      ++ [vlc];
  };
}
