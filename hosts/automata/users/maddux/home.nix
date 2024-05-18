{ pkgs, username, config, lib, inputs, ... }:
{
  imports = [../../../../modules/home-manager/default.nix];
  config = {
    modules = {
      alacritty.enable = true;
      nvim.enable = true;
      zsh.enable = true;
      hyprland = {
        enable = true;
        enableNvidia = false;
      };
      git.enable = true;
      dunst.enable = true;
      games.enable = true;
      tmux.enable = true;
    };
  };
}
