{
  inputs,
  nixpkgs,
  system,
  ...
}: let
  overlays = [
    overlay-unstable
    inputs.niri.overlays.niri
  ];
  overlay-unstable = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
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
