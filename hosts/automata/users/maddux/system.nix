{ pkgs, inputs, ... }:
{
    isNormalUser = true;
    groups = [ "audio" "docker" "input" "wheel" ];
    shell = pkgs.zsh;
    uid = 1000;
    isAllowedNix = true;
    #nix.settings.allowed-users = [ username ];
}
