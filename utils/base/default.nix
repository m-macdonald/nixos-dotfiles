{lib}: {
  attrsets = import ./attrsets.nix {inherit lib;};
  lsLib = import ./lslib.nix {};
}
