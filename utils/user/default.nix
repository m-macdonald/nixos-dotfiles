/*
{
  nixpkgs,
  pkgs,
  home-manager,
  system,
  lib,
  overlays,
  inputs,
  ...
}: {
  lsLib = import ./lslib.nix { inherit lib; };
  user = import ./user.nix { inherit nixpkgs pkgs home-manager lib overlays system inputs; };
  attrsets = import ./attrsets.nix { inherit lib; };
}
*/
{ nixpkgs, pkgs, home-manager, system, lib, inputs, ...  }:
{
	user = import ./user.nix { inherit nixpkgs pkgs home-manager lib system inputs; };
}
