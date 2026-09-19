{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        monospace = ["JetBrains Mono" "Symbols Nerd Font Mono"];
      };
    };
  };
}
