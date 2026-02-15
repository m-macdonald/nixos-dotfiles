{ nixpkgs, pkgs, home-manager, lib, inputs, ...  }:
{
	user = import ./user.nix { inherit nixpkgs pkgs home-manager lib inputs; };
}
