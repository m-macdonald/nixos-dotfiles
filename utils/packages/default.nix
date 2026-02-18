{
  inputs,
  nixpkgs,
  system,
  ...
}: let
  volta-package = ../../packages/volta.nix;
  flameshot-package = ../../packages/flameshot.nix;
  swww-package = ../../packages/swww.nix;

  overlays = [
    overlay-unstable
    overlay-volta
    #      import ./overlays/flameshot
    overlay-flameshot
    overlay-swww
    inputs.niri.overlays.niri
  ];
  overlay-unstable = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
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

  override-nur = pkgs:
    import inputs.nur {
      inherit pkgs;
      nurpkgs = inputs.nixpkgs.legacyPackages."${pkgs.stdenv.hostPlatform.system}";
    };
in
  import nixpkgs {
    inherit overlays system;
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = override-nur pkgs;
      };
    };
  }
