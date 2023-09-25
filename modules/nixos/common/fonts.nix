{  config, lib, pkgs, ... }: 
{
  fonts = {
    fonts = with pkgs; [
      nerdfonts
    ];

    fontconfig = {
      hinting.autohint = true;
    };
  };
}
