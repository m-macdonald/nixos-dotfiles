{pkgs, ...}: {
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
    # Utilities
    unzipNLS
  ];
}
