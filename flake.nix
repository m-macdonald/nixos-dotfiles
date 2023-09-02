{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";
#    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nur, ... }@inputs : 
  let
    utils = import ./utils {
      inherit system nixpkgs pkgs home-manager lib overlays /* patchedPkgs */inputs;
    };
    
    volta-package = ./packages/volta.nix;
    flameshot-package = ./packages/flameshot.nix;
    swww-package = ./packages/swww.nix;

    overlays = [ 
      overlay-unstable
      overlay-volta
      overlay-flameshot
      overlay-swww
    ];

    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
      inherit system;
      config = { 
        allowUnfree = true;
        packageOverrides = pkgs: {
          steam = override-steam pkgs;
          nur = override-nur pkgs;
        };
      };
      overlays = overlays;
    };

    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };

    overlay-volta = final: prev: {
      volta = prev.callPackage volta-package {};
    };

    overlay-flameshot = final: prev: {
      flameshot = prev.callPackage flameshot-package {};
    };

    overlay-swww = final: prev: {
      swww = prev.callPackage swww-package {};
    };

    override-steam = pkgs: 
      pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
      };

    override-nur = pkgs:
      import nur { 
        nurpkgs = nixpkgs.legacyPackages.x86_64-linux;
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    
    lib = nixpkgs.lib;

    mkSystem = folder: hostname:
      lib.nixosSystem {
        system = import ./${folder}/${hostname}/_localSystem.nix;

        modules = [
          { networking.hostName = hostname; }
          (./. + "/hosts/${hostname}/system-configuration.nix")
          (./. + "/hosts/${hostname}/hardware-configuration.nix")
        ];
        specialArgs = { inherit inputs; inherit pkgs; };
      };

    mkUsers = folder: hostname:
      builtins.listToAttrs
      (
        map 
        (username: 
        let 
          usersFolder = "/${folder}/${hostname}/users/${username}";
        in
        {
          name = "${username}@${hostname}";
          value = utils.user.mkHmUser {
            username = username;
            userConfig = (./. + "${usersFolder}/home.nix");
          };
        })
        (utils.lsLib.ls ./${folder}/${hostname}/users)
      );

  in {
    homeManagerConfigurations = (folder:
    utils.attrsets.recursiveMerge (
      builtins.map 
      (hostname: mkUsers folder hostname)
      (utils.lsLib.ls ./${folder})
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
        (utils.lsLib.ls ./${folder})
      )) "hosts";
  };
}
