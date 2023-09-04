{ pkgs, inputs, ... }:
{
    isNormalUser = true;
    groups = [ "input" "wheel" "docker" ];
    shell = pkgs.zsh;
    uid = 1000;
    # nix.settings.allowed-users = [ username ];
}
