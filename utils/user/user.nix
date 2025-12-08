{ pkgs, home-manager, lib, system, inputs, ... }:
{
    mkHmUser = { userConfig, username }:
        home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
                ../../modules
                ../../utils/hosts
                {
                    home = {
                        username = username;
                        homeDirectory = "/home/${username}";
                        stateVersion = "22.11";
                    };
                }
                userConfig
            ];
            extraSpecialArgs = { inherit inputs system; };
        };

    mkSystemUser = { username, groups, uid, shell, ... }: {
        name = username;
        isNormalUser = true;
        isSystemUser = false;
        extraGroups = groups;
        uid = uid;
        initialPassword = "changeme";
        shell = shell;
    };
}
