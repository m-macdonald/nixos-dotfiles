{
  pkgs ? import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.11.tar.gz";
    sha256 = "sha256:11w3wn2yjhaa5pv20gbfbirvjq6i3m7pqrq2msf0g7cv44vijwgw";
  }) {}
}:
#pkgs.stdenv.mkDerivation rec {
pkgs.rustPlatform.buildRustPackage rec {
  pname = "volta";
  version = "0.1.0";
/*
  src = pkgs.fetchzip {
    url = "https://github.com/volta-cli/volta/releases/download/v1.1.1/volta-1.1.1-linux.tar.gz";
    sha256 = "sha256-ZP+UP3uEFgGLkKSzXcb/u+xFUvJdmFFSn92T36jLph4=";
    stripRoot = false;
  };

  buildInputs = with pkgs; [ ];
*/
/*
  src = pkgs.fetchzip {
    url = "https://github.com/volta-cli/volta/archive/refs/tags/v1.1.1.tar.gz";
    sha256 = "sha256-+j3WRpunV+3YfZnyuKA/CsiKr+gOaP2NbmnyoGMN+Mg=";
  };

  buildInputs = with pkgs; [ rustup ];
  
  buildPhase = ''
    cargo build
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv volta volta-migrate volta-shim $out/bin
  '';

  */

  src = pkgs.fetchzip {
    url = "https://github.com/volta-cli/volta/archive/refs/tags/v1.1.1.tar.gz";
    sha256 = "sha256-+j3WRpunV+3YfZnyuKA/CsiKr+gOaP2NbmnyoGMN+Mg=";
  };

  cargoSha256 = "sha256-FEOUMKb0PM/p6kbEaNwLX5hXaHX2eLFp5V2yQSRu9rU=";
}
