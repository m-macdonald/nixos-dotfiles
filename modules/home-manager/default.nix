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
    ../../utils/hosts
  ];

  home.packages = with pkgs; [
    # Utilities
    unzipNLS
  ];
}
