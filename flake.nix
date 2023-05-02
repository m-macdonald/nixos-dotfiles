{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/";
#    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
#    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs : 
  let
    system = "x86_64-linux";
    volta-package = ./packages/volta.nix;
    /*
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = { allowUnfree = true; };
    };
    */

    pkgs = import nixpkgs {
      inherit system;
      config = { 
        allowUnfree = true;
      };
      overlays = [ overlay-unstable overlay-volta/*inputs.nixpkgs-wayland.overlay*/ ];
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
    
    lib = nixpkgs.lib;

    mkSystem = pkgs: system: hostname:
      nixpkgs.lib.nixosSystem {
        system = system;

        modules = [
          { networking.hostName = hostname; }

#          ./modules/system/configuration.nix
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
      nixtop = mkSystem pkgs "x86_64-linux" "desktop";
    };
  };
}
