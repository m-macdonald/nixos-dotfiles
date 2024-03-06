{ config, pkgs, inputs, ... }:
{
  imports = [
    ./amd
    ./common
    ./docker
    ./hyprland
    ./network-shares
    ./nvidia
  ];
}
