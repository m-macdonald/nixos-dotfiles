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
    ./nvim
    ./tmux
    ./zsh
    ./dev
    ./spotify
  ];

  home.packages = with pkgs; [
    # TODO: Bitwarden launches to a blank screen. Find a fix. In the meantime, I'm using the browser extension.
#    bitwarden
    # Utilities
    unzipNLS
  ];
}
