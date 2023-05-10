{ config, pkgs, inputs, ... }:
{
  # DO NOT CHANGE
  home.stateVersion = "22.11";

  imports = [
    ./alacritty
    ./nvim
    ./hyprland
    ./zsh
    ./git
    ./dunst
  ];

  home.packages = with pkgs; [
    spotify
    firefox
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
