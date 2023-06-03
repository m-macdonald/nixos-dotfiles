{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/";
    xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";
#    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nur, ... }@inputs : 
  let
    system = "x86_64-linux";
    volta-package = ./packages/volta.nix;
    flameshot-package = ./packages/flameshot.nix;
    swww-package = ./packages/swww.nix;

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

    mkSystem = pkgs: system: hostname:
      nixpkgs.lib.nixosSystem {
        system = system;

        modules = [
          { networking.hostName = hostname; }
          (./. + "/hosts/${hostname}/system-configuration.nix")
          (./. + "/hosts/${hostname}/hardware-configuration.nix")
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; inherit pkgs; };
              users.maddux = (./. + "/hosts/${hostname}/users.nix");
            };
          }
        ];
        specialArgs = { inherit inputs; inherit pkgs; };
      };

  in { 
    nixosConfigurations = {
      desktop = mkSystem pkgs "x86_64-linux" "desktop";
    };
  };
}
