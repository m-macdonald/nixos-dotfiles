{pkgs, ...}: {
  imports = [
    ./alacritty
    ./dunst
    ./games
    ./git
    ./helium
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
