{ nixpkgs ? import <nixpkgs> { }}:
let 
  rustOverlay = builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
  pinnedPkgs = nixpkgs.fetchFromGitHub {
    owner = "NixOs";
    repo = "nixpkgs";
    rev = "4d2b37a84fad1091b9de401eb450aae66f1a741e";
    sha256 = "sha256-/HEZNyGbnQecrgJnfE8d0WC5c1xuPSD2LUpB6YXlg4c=";
  };
  pkgs = import pinnedPkgs {
    overlays = [ (import rustOverlay) ];
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    rust-bin.stable.latest.default

    openssl
    pkg-config
  ];

  RUST_BACKTRACE = 1;
}
