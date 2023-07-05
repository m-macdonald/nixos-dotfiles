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
    # TODO: Bitwarden launches to a blank screen. Find a fix. In the meantime, I'm using the browser extension.
#    bitwarden
    # Utilities
    unzipNLS
    #Snipping tool
    flameshot
    grim
  ];
}
