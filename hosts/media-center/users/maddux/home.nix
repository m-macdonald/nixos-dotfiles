{ ... }:
{
    imports = [../../../../modules/home-manager/default.nix];
    config = {
        modules = {
            alacritty.enable = true;
            nvim.enable = true;
            zsh.enable = true;
            git.enable = true;
            tmux.enable = true;
        };
    };
}
