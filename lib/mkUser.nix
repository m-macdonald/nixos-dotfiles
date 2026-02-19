{
  pkgs,
  inputs,
  ...
}: {
  mkHmUser = {
    userConfig,
    username,
  }: let
    self = inputs.self;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        "${self}/modules/home-manager"
        inputs.nixvim.homeManagerModules.${pkgs.stdenv.hostPlatform.system}.nixvim
        {
          home = {
            username = username;
            homeDirectory = "/home/${username}";
            stateVersion = "22.11";
          };
        }
        userConfig
      ];
      extraSpecialArgs = {inherit inputs;};
    };

  mkSystemUser = {
    username,
    groups,
    uid,
    shell,
    ...
  }: {
    name = username;
    isNormalUser = true;
    isSystemUser = false;
    extraGroups = groups;
    uid = uid;
    initialPassword = "changeme";
    shell = shell;
  };
}
