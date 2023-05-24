{
  pkgs
}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.7.3";

  src = pkgs.fetchzip {
    url = "https://github.com/Horus645/swww/archive/refs/tags/v${version}.zip";
    sha256 = "sha256-58zUi6tftTvNoc/R/HO4RDC7n+NODKOrBCHH8QntKSY=";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    libxkbcommon
  ];

  cargoSha256 = "sha256-hL5rOf0G+UBO8kyRXA1TqMCta00jGSZtF7n8ibjGi9k=";
}
