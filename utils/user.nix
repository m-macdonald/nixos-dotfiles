{ pkgs, home-manager, lib, system, overlays, ... }:
{
  mkHmUser = { userConfig, username }:
    home-manager.lib.homeManagerConfiguration {
      inherit system username pkgs;
      stateVersion = "";
      configuration = {
        user = userConfig;

        nixpkgs.overlays = overlays;
        nixpkgs.config.allowUnfree = true;

        systemd.user.startServices = true;
        home.stateVersion = "";
        home.username = username;
        home.homeDirectory = "/home/${username}";

        imports = [ ../modules ];
      };

      homeDirectory = "/home/${username}";
    };


  mkSystemUser = { username, groups, uid, shell, ... }:
  {
    users.users."${username}" = {
      name = username;
      isNormalUser = true;
      isSystemUser = false;
      extraGroups = groups;
      uid = uid;
      initialPassword = "changeme";
      shell = shell;
    };
  };
}
