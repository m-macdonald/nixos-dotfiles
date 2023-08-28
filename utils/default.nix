{
  nixpkgs,
  pkgs,
  home-manager,
  system,
  lib,
  inputs,
  ...
}: {
  lsLib = import ./lslib.nix { inherit lib; };
  user = import ./user.nix { inherit nixpkgs pkgs home-manager lib system inputs; };
}
