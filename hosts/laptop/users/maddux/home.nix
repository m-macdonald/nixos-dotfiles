{ pkgs, username, config, lib, inputs, ... }:
{
  imports = [
        ../../../../modules/home-manager/default.nix
        ../../monitors.nix
  ];
  config = {
    modules = {
      alacritty.enable = true;
      nvim.enable = true;
      rdp.client.enable = true;
      niri.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      git.enable = true;
      dunst.enable = true;
      tmux.enable = true;
    };
  };
}
