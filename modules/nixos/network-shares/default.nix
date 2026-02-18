{
  pkgs,
  config,
  lib,
  ...
}: let
  options = [
    "x-systemd.automount"
    "noauto"
    "x-systemd.idle-timeout=300"
    "x-systemd.device-timeout=5s"
    "x-systemd.mount-timeout=30s"
    "credentials=/run/secrets/nas"
    "rw"
    "uid=${toString config.users.users.maddux.uid}"
    "gid=${toString config.users.groups.users.gid}"
    "file_mode=0777"
    "dir_mode=0777"
    "noperm"
  ];
in {
  config = {
    environment.systemPackages = [pkgs.cifs-utils];

    sops.secrets.nas = {};

    fileSystems = {
      "/mnt/nas/media" = {
        device = "//tower/media";
        fsType = "cifs";
        options = options;
      };
    };

    security.wrappers."mount.cifs" = {
      program = "mount.cifs";
      source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
      owner = "root";
      group = "root";
      setuid = true;
    };
  };
}
