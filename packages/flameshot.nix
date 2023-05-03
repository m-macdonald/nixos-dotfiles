{ 
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.11.tar.gz";
    sha256 = "sha256:11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";
  }) {}
  /*
  mkDerivation,
  lib,
  fetchFromGithub,
  qtbase,
  cmake,
  qttools,
  qtsvg,
  nix-update-script
  */
}:
pkgs.stdenv.mkDerivation rec {
  pname = "flameshot";
  version = "12.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    # Latest commit on master at time of this package creation
    # Attempts to add support for hyprland
    rev = "3ededae";
    sha256 = "sha256-4SMg63MndCctpfoOX3OQ1vPoLP/90l/KGLifyUzYD5g=";
  };

  passthru = {
    updateScript = pkgs.nix-update-script {
      attrPath = pname;
    };
  };

  nativeBuildInputs = with pkgs; [ cmake qt5.qttools qt5.qtsvg qt5.wrapQtAppsHook libsForQt5.kguiaddons ];
  buildInputs = with pkgs.qt5; [ qtbase ];

  configurePhase = ''
    # mkdir -p build
    # cd build
    cmake ./ \
      -DUSE_WAYLAND_CLIPBOARD=1 \
      -DUSE_WAYLAND_GRIM=true
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv src/flameshot $out/bin
  '';
}
