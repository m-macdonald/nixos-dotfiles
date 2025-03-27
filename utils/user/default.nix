{ nixpkgs, pkgs, home-manager, system, lib, inputs, ...  }:
{
	user = import ./user.nix { inherit nixpkgs pkgs home-manager lib system inputs; };
}
