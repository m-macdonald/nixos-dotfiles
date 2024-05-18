{ config, pkgs, inputs, ... }:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "maddux" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
