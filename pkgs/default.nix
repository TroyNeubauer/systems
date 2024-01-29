{ pkgs ? (import ../nixpkgs.nix) { } }: rec {
  wrapWine = pkgs.callPackage ./wrapWine.nix { };
  kindle_1_17 = pkgs.callPackage ./wineApps/kindle.nix {
    inherit wrapWine;
  };
}
