{ pkgs, ... }:
{
  imports = [
    ./alacritty
    ./dunst
    ./firefox
    ./games
    ./git
    ./hyprland
    ./kodi
    ./mkv
    ./niri
    ./nvim
    ./tmux
    ./zsh
    ./dev
    ./rdp
    ./spotify
    ../../utils/hosts
  ];

  home.packages = with pkgs; [
    # TODO: Bitwarden launches to a blank screen. Find a fix. In the meantime, I'm using the browser extension.
#    bitwarden
    # Utilities
    unzipNLS
  ];
}
