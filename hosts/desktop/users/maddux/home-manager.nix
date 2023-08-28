{ pkgs, username, config, lib, inputs, ... }:
{
  imports = [../../../../modules/default.nix];
  #
  # isNormalUser = true;
  # extraGroups = [ "input" "wheel" "docker" ];
  # shell = pkgs.zsh;
  # nix.settings.allowed-users = [ username ];
  config = {
    modules = {
      alacritty.enable = true;
      nvim.enable = true;
      zsh.enable = true;
      hyprland.enable = true;
      git.enable = true;
      dunst.enable = true;
      games.enable = true;
    };
  };
}
