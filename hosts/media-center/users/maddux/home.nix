{...}: {
  imports = [../../../../modules/home-manager/default.nix];
  config = {
    modules = {
      alacritty.enable = true;
      git.enable = true;
      kodi.enable = true;
      mkv.enable = true;
      nvim.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };
  };
}
