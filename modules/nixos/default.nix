{ config, pkgs, inputs, ... }:
{
  imports = [
    ./common
    ./docker
    ./network-shares
    ./nvidia
    ./hyprland
  ];
}
