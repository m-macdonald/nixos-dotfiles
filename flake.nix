{
  description = "My Nixos Configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    nixvim = {
      url = "github:m-macdonald/nixvim-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    play-nix = {
      url = "github:TophC7/play.nix/fea2ccf";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dw-proton.url = "github:imaviso/dwproton-flake";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    nur,
    nixos-hardware,
    sops-nix,
    arion,
    play-nix,
    niri,
    dw-proton,
    noctalia,
    ...
  } @ inputs: let
    lib = nixpkgs.lib;

    baseUtils = import ./utils/base {inherit lib;};

    mkSystem = folder: hostname: let
      system = import ./${folder}/${hostname}/_localSystem.nix;
      pkgs = import ./utils/packages {inherit system nixpkgs inputs;};
      userUtils = import ./utils/user {
        inherit nixpkgs system pkgs home-manager lib inputs;
      };
      additionalModulesPath = ./${folder}/${hostname}/additional-modules.nix;
      additionalModulesExist = builtins.pathExists additionalModulesPath;
      additionalModules = lib.lists.optionals additionalModulesExist (import additionalModulesPath inputs).modules;
      systemConfigurationPath = ./${folder}/${hostname}/system-configuration.nix;
      hardwareConfigurationPath = ./${folder}/${hostname}/hardware-configuration.nix;
    in
      lib.nixosSystem
      {
        inherit system;

        modules =
          [
            {nixpkgs.pkgs = pkgs;}
            play-nix.nixosModules.play
            sops-nix.nixosModules.sops
            {networking.hostName = hostname;}
            systemConfigurationPath
            hardwareConfigurationPath
            ({config, ...}: {
              sops = {
                defaultSopsFile = ./secrets/secrets.yaml;
                age = {
                  keyFile = "/var/lib/sops-nix/key.txt";
                  generateKey = false;
                };
                secrets = {
                  "users/maddux/password" = {
                    neededForUsers = true;
                  };
                  "vpn/home_server/public_key" = {};
                  "vpn/home_server/private_key" = {};
                  "vpn/home_server/preshared_key" = {};
                };
              };
              users = {
                mutableUsers = false;
                users = builtins.listToAttrs (
                  map
                  (
                    username: let
                      userFolder = "./${folder}/${hostname}/users/${username}";
                    in {
                      name = username;
                      value = userUtils.user.mkSystemUser ({inherit username;} // (import ./${userFolder}/system.nix {inherit inputs pkgs;}));
                    }
                  )
                  (baseUtils.lsLib.ls ./${folder}/${hostname}/users)
                );
              };
            })
          ]
          ++ additionalModules;
        specialArgs = {inherit inputs;};
      };

    mkUsers = folder: hostname: let
      system = import ./${folder}/${hostname}/_localSystem.nix;
      pkgs = import ./utils/packages {inherit system nixpkgs inputs;};
      userUtils = import ./utils/user {
        inherit nixpkgs system pkgs home-manager lib inputs;
      };
    in
      builtins.listToAttrs
      (
        map
        (username: let
          userFolder = "${folder}/${hostname}/users/${username}";
        in {
          name = "${username}@${hostname}";
          value = userUtils.user.mkHmUser {
            username = username;
            userConfig = ./${userFolder}/home.nix;
          };
        })
        (baseUtils.lsLib.ls ./${folder}/${hostname}/users)
      );
  in {
    homeManagerConfigurations = (
      folder:
        baseUtils.attrsets.recursiveMerge (
          builtins.map
          (hostname: mkUsers folder hostname)
          (baseUtils.lsLib.ls ./${folder})
        )
    ) "hosts";

    nixosConfigurations = (folder:
      builtins.listToAttrs
      (
        map
        (hostname: {
          name = hostname;
          value = mkSystem folder hostname;
        })
        (baseUtils.lsLib.ls ./${folder})
      )) "hosts";
  };
}
