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
      inherit system nixpkgs pkgs home-manager lib /* overlays patchedPkgs */inputs;
    };
    
    volta-package = ./packages/volta.nix;
    flameshot-package = ./packages/flameshot.nix;
    swww-package = ./packages/swww.nix;

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
      overlays = [ 
        overlay-unstable
        overlay-volta
        overlay-flameshot
        overlay-swww
        overlay-bitwarden
      ];
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

    overlay-bitwarden = final: prev: {
      bitwarden = prev.bitwarden.overrideAttrs (old: rec {
        name = "bitwarden";
        version = "2023.4.0";
        src = prev.fetchurl {
          url = "https://github.com/bitwarden/clients/releases/download/desktop-v${version}/Bitwarden-${version}-amd64.deb";
          sha256 = "sha256-fpPxB4FdPe5tmalSRjGCrK3/0erazhg8SnuGdlms8bk=";
        };
      });
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

    mkSystem = folder: name:
      lib.nixosSystem {
        system = import ./${folder}/${name}/_localSystem.nix;

        modules = [
          { networking.hostName = name; }
          (./. + "/hosts/${name}/system-configuration.nix")
          (./. + "/hosts/${name}/hardware-configuration.nix")
#          (./. + "/modules/default.nix")
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; inherit pkgs; };
              users.maddux = (./. + "/hosts/${name}/users/maddux/home-manager.nix");
            };
          }
        ];
        specialArgs = { inherit inputs; inherit pkgs; };
      };
  in {
      nixosConfigurations = (folder: 
        builtins.listToAttrs 
        (
          map
          (x: {
            name = x;
            value = mkSystem folder x;
          })
          (utils.lsLib.ls ./${folder})
        )) "hosts";
  };
}
