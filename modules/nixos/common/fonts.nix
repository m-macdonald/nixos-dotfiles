{  config, lib, pkgs, ... }: 
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.droid-sans-mono
    ];

    fontconfig = {
      hinting.autohint = true;
    };
  };
}
