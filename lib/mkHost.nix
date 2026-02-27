# Provides `mkSystem` (NixOS configuration) and `mkUsers` (Home Manager
# configurations) for a given hostname directory under hosts/.
{
  inputs,
  lib,
  ls,
  mkPkgs,
}: let
  self = inputs.self;

  globalSecrets = import ./secrets.nix;

  hostsDir = "${self}/hosts";

  hostPath = hostname: relativePath: "${hostsDir}/${hostname}/${relativePath}";

  # ── Secrets ────────────────────────────────────────────────────────────────

  # Merge global secrets with any host-specific overrides.
  # Host values take precedence via //.
  mkSecrets = hostname: let
    hostSecretsPath = hostPath hostname "secrets.nix";
    hostSecrets =
      if builtins.pathExists hostSecretsPath
      then import hostSecretsPath
      else {};
  in
    globalSecrets // hostSecrets;

  mkSopsModule = hostname: {
    sops = {
      defaultSopsFile = "${self}/secrets/secrets.yaml";
      age = {
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = false;
      };
      secrets = mkSecrets hostname;
    };
  };

  # ── Users ──────────────────────────────────────────────────────────────────
  mkSystemUsersModule = hostname: pkgs: {config, ...}: let
    userLib = import ./mkUser.nix {inherit pkgs inputs;};
    usernames = ls (hostPath hostname "users");
  in {
    users = {
      mutableUsers = false;
      users = builtins.listToAttrs (
        map (username: {
          name = username;
          value = userLib.mkHostUser (
            {inherit username config;}
            // (import (hostPath hostname "users/${username}/system.nix") {inherit inputs pkgs;})
          );
        })
        usernames
      );
    };
  };

  # ── Public functions ────────────────────────────────────────────────────────
  mkSystem = hostname: let
    system = import (hostPath hostname "arch.nix");
    pkgs = mkPkgs system;
  in
    lib.nixosSystem {
      inherit system;
      modules = [
        "${self}/modules/nixos"
        {nixpkgs.pkgs = pkgs;}
        inputs.play-nix.nixosModules.play
        inputs.sops-nix.nixosModules.sops
        {networking.hostName = hostname;}
        (hostPath hostname "system-configuration.nix")
        (hostPath hostname "hardware-configuration.nix")
        (mkSopsModule hostname)
        (mkSystemUsersModule hostname pkgs)
      ];
      specialArgs = {inherit inputs;};
    };

  mkUsers = hostname: let
    system = import (hostPath hostname "arch.nix");
    pkgs = mkPkgs system;
    userLib = import ./mkUser.nix {inherit pkgs inputs;};
    usernames = ls (hostPath hostname "users");
  in
    builtins.listToAttrs (
      map (username: {
        name = "${username}@${hostname}";
        value = userLib.mkHmUser {
          inherit username;
          userConfig = hostPath hostname "users/${username}/home.nix";
        };
      })
      usernames
    );
in {
  inherit mkSystem mkUsers;
}
