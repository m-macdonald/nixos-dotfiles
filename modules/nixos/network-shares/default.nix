{  pkgs, config, ... }:
let
    options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=300" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=30s" "uid=nobody" "gid=users" "credentials=/run/secrets/nas" ];
in
{
    config = {
        environment.systemPackages = [ pkgs.cifs-utils ];

        sops.secrets.nas = {};

        fileSystems = {
            "/mnt/nas/appdata" = {
                device = "//tower/appdata";
                fsType = "cifs";
                options = options;
            };
            "/mnt/nas/media" = {
                device = "//tower/Media";
                fsType = "cifs";
                options = options;
            };
        };
    };
}
