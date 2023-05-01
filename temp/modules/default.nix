{ inputs, pkgs, config, ... }: 
{
  imports = [
    ./hyprland
    ./terminal
    ./wayland
  ];
}
