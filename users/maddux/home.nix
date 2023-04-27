{ inputs, config, pkgs, ... }: 
{
  imports = [
    ./shell
    ../../modules/hyprland
  ];

#  home.file.".ssh/allowed_sigmers".text = "${builtins.readFile /home/maddux/.ssh/github.pub}";
  
  home.username	= "maddux";
  home.homeDirectory = "/home/maddux";

  home.packages = with pkgs; [
    alacritty
    spotify
    firefox
    neovim
    rofi
    git
  ];

   programs.git = {
      enable = true;
      userName = "m-macdonald";
      userEmail = "37754975+m-macdonald@users.noreply.github.com";
      extraConfig = {
        init = {defaultBranch = "main";};
        commit.gpgsign = true;
	gpg.format = "ssh";
	gpg.ssh.allowedSignersFile = "~/.ssh/github.pub";
	user.signingkey = "~/.ssh/github.pub";
      };
    };

    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "tty";
    };

  home.stateVersion = "22.11";
}
