{  config, lib, pkgs, ... }: 
{
  home.packages = with pkgs; [zsh];

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

/*
  programs.git = {
    enable = true;
    userName = "m-macdonald";
    package = pkgs.gitFull;
    extraConfig = {
      init = {defaultBranch = "main";};
      credential.helper = "libsecret";
    };
  };
*/
}
