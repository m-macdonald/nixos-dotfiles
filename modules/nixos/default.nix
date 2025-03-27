{ config, pkgs, inputs, ... }:
{
  imports = [
    ./amd
    ./common
    ./docker
    ./kodi
    ./hyprland
    ./network-shares
    ./nvidia
    ./plasma-bigscreen
    ./podman
    ./rdp
  ];
}
