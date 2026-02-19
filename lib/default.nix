{inputs}: let
  nixpkgs = inputs.nixpkgs;
  lib = nixpkgs.lib;

  ls = path: (builtins.attrNames (builtins.readDir path));

  mergeAttrs = attrList:
    with lib; let
      f = attrPath:
        zipAttrsWith (n: values:
          if tail values == []
          then head values
          else if all isList values
          then unique (concatLists values)
          else if all isAttrs values
          then f (attrPath ++ [n]) values
          else last values);
    in
      f [] attrList;

  mkPkgs = system: import ./mkPkgs.nix {inherit inputs system;};

  mkHost = import ./mkHost.nix {inherit inputs lib ls mkPkgs;};
in {
  inherit ls mergeAttrs;
  inherit (mkHost) mkSystem mkUsers;
}
