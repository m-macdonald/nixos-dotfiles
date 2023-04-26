{ inputs, config, pkgs, ... }: 
{
  imports = [
    ./shell
    ../../modules/hyprland
  ];
  
  home.username	= "maddux";
  home.homeDirectory = "/home/maddux";

  home.packages = with pkgs; [
#    hyprland
    alacritty
    spotify
    firefox
    neovim
    rofi
  ];

  home.stateVersion = "22.11";
}
