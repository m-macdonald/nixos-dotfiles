{
  ...
}: {
  imports = [../../../../modules/home-manager/default.nix];
  config = {
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
