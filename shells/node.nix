{ pkgs ? import <nixpkgs> {} }:
let
  lib = import <nixpkgs/lib>;
  buildNodejs = pkgs.callPackage <nixpkgs/pkgs/development/web/nodejs/nodejs.nix> {};

  nodejsVersion = lib.fileContents ./.nvmrc;

  nodejs = buildNodeJs {
    enableNpm = true;
    version = '';

  };
