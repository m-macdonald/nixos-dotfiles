{ pkgs, inputs, ... }:
{
    isNormalUser = true;
    groups = [ "input" "wheel" ];
    shell = pkgs.zsh;
    uid = 1000;
    isAllowedNix = true;
    #nix.settings.allowed-users = [ username ];
}
