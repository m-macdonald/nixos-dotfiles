{ nixpkgs, nixpkgs-unstable, system, nur }:
{
	buildPkgs = 
	let
		pkgs = nixpkgs.legacyPackages."${system}";

    volta-package = ../../packages/volta.nix;
    flameshot-package = ../../packages/flameshot.nix;
    swww-package = ../../packages/swww.nix;

    overlays = [ 
      overlay-unstable
      overlay-volta
#      import ./overlays/flameshot
      overlay-flameshot
      overlay-swww
    ];
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
        inherit pkgs;
        nurpkgs = nixpkgs.legacyPackages."${system}";
      };
    in 
    import nixpkgs {
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
}


