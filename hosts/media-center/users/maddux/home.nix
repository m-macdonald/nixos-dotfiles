{ ... }:
{
    imports = [../../../../modules/home-manager/default.nix];
    config = {
        modules = {
            alacritty.enable = false;
            nvim.enable = false;
            zsh.enable = true;
            git.enable = true;
            tmux.enable = false;
        };
    };
}
