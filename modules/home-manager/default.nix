{pkgs, ...}: {
  imports = [
    ./alacritty
    ./dunst
    ./gaming
    ./git
    ./helium
    ./hyprland
    ./kodi
    ./librewolf
    ./localsend
    ./mkv
    ./niri
    ./noctalia
    ./nvim
    ./tmux
    ./zsh
    ./dev
    ./rdp
    ./spotify
    ./thunar
  ];

  home.packages = with pkgs; [
    # Utilities
    unzipNLS
  ];
}
