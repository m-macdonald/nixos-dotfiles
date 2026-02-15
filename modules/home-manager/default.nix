{ pkgs, ... }:
{
  imports = [
    ./alacritty
    ./dunst
    ./games
    ./git
    ./hyprland
    ./kodi
    ./librewolf
    ./mkv
    ./niri
    ./noctalia
    ./nvim
    ./tmux
    ./zsh
    ./dev
    ./rdp
    ./spotify
  ];

  home.packages = with pkgs; [
    # TODO: Bitwarden launches to a blank screen. Find a fix. In the meantime, I'm using the browser extension.
#    bitwarden
    # Utilities
    unzipNLS
  ];
}
