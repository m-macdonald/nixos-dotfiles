{ config, pkgs, inputs, ... }:
{
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
    # Dev
    dbeaver
    unstable.obsidian

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
