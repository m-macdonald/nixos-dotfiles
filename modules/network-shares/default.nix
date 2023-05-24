{ config, lib, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.cifs-utils ]; 
  fileSystems = {
    "/mnt/nas/appdata" = {
      device = "//tower/appdata";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout-60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,noperms,uid=nobody,gid=users";
      in [ "${automount_opts},credentials=/etc/nixos/tower-secrets" ];
    };
    "mnt/nas/media" = {
      device = "//tower/Media";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout-60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,noperms,uid=nobody,gid=users";
      in [ "${automount_opts},credentials=/etc/nixos/tower-secrets" ];
    };
  };
}
