{
  description = "My Nixos Configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    # hyprland.url = "github:hyprwm/Hyprland/";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";
    nixvim = {
      url = "github:m-macdonald/nixvim-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    arion.url = "github:hercules-ci/arion";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nur, nixos-hardware, arion, ... }@inputs : 
  let
	nixlib = nixpkgs.lib;

	baseUtils = import ./utils/base {
		lib = nixlib;
	};
    
    mkSystem = folder: hostname:
    let
	systemPath = ./${folder}/${hostname};
      system = import ./${folder}/${hostname}/_localSystem.nix;
	pkgUtils = import ./utils/packages { inherit system nixpkgs nixpkgs-unstable nur; };
	pkgs = pkgUtils.buildPkgs;
#	pkgs = nixpkgs.legacyPackages.${system};
	lib = pkgs.lib;
	userUtils = import ./utils/user {
     	 inherit system nixpkgs pkgs home-manager lib inputs;
    	};
	additionalModulesPath = ./${folder}/${hostname}/additional-modules.nix;
	additionalModulesExist = builtins.pathExists additionalModulesPath;
	additionalModules = nixlib.lists.optionals additionalModulesExist (import additionalModulesPath inputs).modules;
	systemConfigurationPath = ./${folder}/${hostname}/system-configuration.nix;
	hardwareConfigurationPath = ./${folder}/${hostname}/hardware-configuration.nix;
    in nixlib.nixosSystem
      {
        inherit system; 

        modules = [
          { networking.hostName = hostname; }
	  systemConfigurationPath
	  hardwareConfigurationPath
          {users.users = builtins.listToAttrs (
            map
            (username:
              let userFolder = "./${folder}/${hostname}/users/${username}";
              in
              {
                name = username;
                value = userUtils.user.mkSystemUser  ({inherit username;} // (import ./${userFolder}/system.nix { inherit pkgs inputs; }));
              }
            )
            (baseUtils.lsLib.ls ./${folder}/${hostname}/users)
          );} 
        ] ++ additionalModules;
        specialArgs = { inherit inputs pkgs; };
      };

    mkUsers = folder: hostname:
    let
      system = import ./${folder}/${hostname}/_localSystem.nix;
	userUtils = import ./utils/user {
     	 inherit system nixpkgs pkgs home-manager lib inputs;
    	};
	pkgUtils = import ./utils/packages { inherit system nixpkgs nixpkgs-unstable nur; };
	pkgs = pkgUtils.buildPkgs;
#	pkgs = nixpkgs.legacyPackages.${system};
	lib = pkgs.lib;
    in builtins.listToAttrs
      (
        map 
        (username: 
        let 
          userFolder = "${folder}/${hostname}/users/${username}";
        in
        {
          name = "${username}@${hostname}";
          value = userUtils.user.mkHmUser {
            username = username;
            userConfig = ./${userFolder}/home.nix;
          };
        })
        (baseUtils.lsLib.ls ./${folder}/${hostname}/users)
      );

	
	pkgs = nixpkgs.legacyPackages."aarch64-linux";
  in {
    homeManagerConfigurations = (folder:
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
