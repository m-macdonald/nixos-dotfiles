{
  pkgs,
  username,
  config,
  lib,
  inputs,
  ...
}: {
  imports = [../../../../modules/home-manager/default.nix];
  config = {
    # isNormalUser = true;
    # extraGroups = [ "input" "wheel" "docker" ];
    # shell = pkgs.zsh;
    # nix.settings.allowed-users = [ username ];
    modules = {
      alacritty.enable = true;
      nvim.enable = true;
      niri.enable = true;
      noctalia.enable = true;
      zsh.enable = true;
      hyprland.enable = false;
      git.enable = true;
      games.enable = true;
      rdp.client.enable = true;
      tmux.enable = true;
    };
  };
}
