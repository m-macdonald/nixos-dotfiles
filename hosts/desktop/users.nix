{ config, lib, inputs, ... }:
{
  imports = [../../modules/default.nix];
  config = {
    modules = {
      alacritty.enable = true;
      neovim.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      git.enable = true;
    };
  };
}
