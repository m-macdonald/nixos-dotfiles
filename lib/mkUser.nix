{
  pkgs,
  inputs,
  ...
}: {
  mkHmUser = {
    userConfig,
    username,
    hostname
  }: let
    self = inputs.self;
    hosts = import ./hosts.nix {inherit inputs;};
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        "${self}/modules/home-manager"
        "${self}/lib/monitors.nix"
        (hosts.hostPath hostname "monitors.nix")
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
