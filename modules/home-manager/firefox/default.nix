{ config, lib, pkgs, ... }:
{
  config = {
    programs.firefox = {
      enable = true;

      # Necessary in order for extensions to be available.
      profiles.default = {
        id = 0;
        name = "Default";
        isDefault = true;
        extensions = with pkgs; [
          # Bitwarden for password management
          nur.repos.rycee.firefox-addons.bitwarden
        ];
      };
    };
  };
}
