{ pkgs, username, config, lib, inputs, ... }:
{
  imports = [../../../../modules/home-manager/default.nix];
  config = {
    modules = {
      alacritty.enable = true;
      nvim.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      git.enable = true;
      dunst.enable = true;
      tmux.enable = true;
    };
  };
}
