{ config, lib, inputs, ... }:
{
  imports = [../../modules/default.nix];
  config = {
    modules = {
      alacritty.enable = true;
      nvim.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      git.enable = true;
    };
  };
}
