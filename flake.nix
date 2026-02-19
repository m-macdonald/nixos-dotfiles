{
  description = "My Nixos Configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
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

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: let
      myLib = import ./lib {inherit inputs;};
      hostnames = myLib.ls ./hosts;
    in {
      systems = lib.unique (map (hostname: import "${inputs.self}/hosts/${hostname}/arch.nix") hostnames);

      flake = {
        nixosConfigurations = builtins.listToAttrs (
          map (hostname: {
            name = hostname;
            value = myLib.mkSystem hostname;
          })
          hostnames
        );

        homeManagerConfigurations = myLib.mergeAttrs (
          map myLib.mkUsers hostnames
        );
      };

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
    });
}
