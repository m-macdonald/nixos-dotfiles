{ inputs, config, pkgs, ... }: 
{
  imports = [
    ../../modules/hyprland
    ./home
  ];

  home.username	= "maddux";
  home.homeDirectory = "/home/maddux";

  home.packages = with pkgs; [
    alacritty
    spotify
    firefox
    neovim
    rofi
    git
    gcc
  ];

   programs.git = {
      enable = true;
      userName = "m-macdonald";
      userEmail = "37754975+m-macdonald@users.noreply.github.com";
      extraConfig = {
        init = {defaultBranch = "main";};
      };
    };

  home.stateVersion = "22.11";
}
