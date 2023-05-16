{ config, pkgs, inputs, ... }:
{
  # DO NOT CHANGE
  home.stateVersion = "22.11";

  imports = [
    ./alacritty
    ./nvim
    ./firefox
    ./hyprland
    ./zsh
    ./git
    ./dunst
    ./games
  ];

  home.packages = with pkgs; [
    spotify
    discord

    rofi
    gcc
    bitwarden
    # Utilities
    unzipNLS
    #Snipping tool
    flameshot
    grim
  ];
}
