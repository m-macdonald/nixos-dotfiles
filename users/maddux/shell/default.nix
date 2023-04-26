{  config, lib, pkgs, ... }: 
{
  home .packages = with pkgs; [zsh];

  home.file = {
    ".zshrc" = {
      source = ./.zshrc;
    };
  };

  programs.zsh = {
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    sessionVariables = {
      EDITOR = "nvim";
    };

  };

  programs.git = {
    enable = true;
    userName = "m-macdonald";
    userEmail = "maddux.macdonald@gmail.com";
    extraConfig = {
      init = {defaultBranch = "main";};
    };
  };
}
