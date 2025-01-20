{ ... }:
{
    imports = [../../../../modules/home-manager/default.nix];
    config = {
        modules = {
            alacritty.enable = false;
            git.enable = true;
	    kodi.enable = true;
	    mkv.enable = true;
            nvim.enable = false;
            tmux.enable = false;
            zsh.enable = true;
        };
    };
}
