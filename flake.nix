{
  description = "My personal dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland/";
#    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
#    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs : 
  let
    system = "x86_64-linux";

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = { allowUnfree = true; };
    };

    pkgs = import nixpkgs {
      inherit system;
      config = { 
        allowUnfree = true;
      };
      overlays = [ overlay-unstable /*inputs.nixpkgs-wayland.overlay*/ ];
    };

    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
    
    lib = nixpkgs.lib;

  in {

    services = {
      pipewire = {
        enable = true;
	pulse.enable = true;
      };
    };

    sound.enable = true;
    hardware.pulseaudio.enable = true;

    homeConfigurations = {
      maddux = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
	extraSpecialArgs = { inherit inputs; };
        modules = [
          ./users/maddux/home.nix
	];
      };
    };

    nixosConfigurations = {
      nixtop = lib.nixosSystem {
        inherit system;
        pkgs = pkgs;
	modules = [
          ./system/configuration.nix
#	  inputs.hyprland.nixosModules.default
#	  {programs.hyprland.enable = true; }
	];
      };
    };
  };
}
