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

  mkHostUser = {
    config,
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
    hashedPasswordFile = config.sops.secrets."users/${username}/password".path; 
    shell = shell;
  };
}
