{ pkgs, lib, config, ... }: 
with lib;
with builtins;
let
in {

  config = {
    home = { 
      sessionVariables = {
        TERM = "${pkgs.alacritty}/bin/alacritty";
      };
      packages = with pkgs; [
        alacritty
      ];
    };

    xdg.configFile."zsh/.zshrc".source = ./.zshrc;
  };
}
