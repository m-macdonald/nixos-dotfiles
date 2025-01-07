{ nixpkgs, nixpkgs-unstable, system, nur }:
{
    buildPkgs = 
    let

	pkgsOverlays = final: prev: (import ../../packages { inherit nixpkgs-unstable system; pkgs = prev; });

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
            overlays = [ pkgsOverlays ];
        };
}


