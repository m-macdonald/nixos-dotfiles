{ inputs, config, pkgs, ... }: 
{
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

  home.file."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/users/maddux/home/neovim/config";
    target = ".config/nvim";
    recursive = true;
  };
}
