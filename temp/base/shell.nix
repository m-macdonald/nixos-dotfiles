{ pkgs, lib, config, ... }:
with pkgs;
with lib;
with builtins;
let 
  cfg = config.sys;
in {
  environment.systemPackages = with pkgs; [
    zsh
  ];

  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
}
