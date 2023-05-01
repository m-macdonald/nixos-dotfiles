{ config, pkgs, inputs, ... }:
{
  # DO NOT CHANGE
  home.stateVersion = "22.11";

  imports = [
    ./alacritty
    ./neovim
    ./hyprland
    ./zsh
  ];

  home.packages = with pkgs; [
    spotify
    firefox
    rofi
    git
    gcc
  ];
}
