{system, pkgs, nixpkgs-unstable}: {

	overlay-unstable = final: prev: {
   		unstable = import nixpkgs-unstable {
			inherit system;
			config.allowUnfree = true;
    		};
	};

	embuary = pkgs.kodiPackages.callPackage ./embuary.nix {};

/*
overlay-swww = final: prev: {
    swww = prev.callPackage swww-package {};
};
*/
}
