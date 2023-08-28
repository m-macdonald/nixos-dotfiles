{ pkgs, home-manager, lib, system, overlays, inputs, ... }:
{
  mkHmUser = { userConfig, username }:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ../modules
        {
          home = {
            username = username;
            homeDirectory = "/home/${username}";
            stateVersion = "22.11";
            /*
            packages = with pkgs; [
              git
            ];
            */
          };
        }
        userConfig
      ];
      extraSpecialArgs = { inherit inputs; };
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
