{ nixpkgs, nixpkgs-unstable, system, nur }:
{
    buildPkgs = 
    let
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
                    nur = override-nur pkgs;
                };
            };
            overlays = overlays;
        };
}


