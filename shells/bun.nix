{ pkgs ? import <nixpkgs> {} }:

let
  lib = import <nixpkgs/lib>;

in pkgs.mkShell {
  packages = with pkgs; [
    bun
    nodejs
    nodePackages.npm
  ];
}
