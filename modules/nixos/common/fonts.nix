{  config, lib, pkgs, ... }: 
{
  fonts = {
    packages = with pkgs; [
      nerdfonts
    ];

    fontconfig = {
      hinting.autohint = true;
    };
  };
}
