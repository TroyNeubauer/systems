{ pkgs ? (import ../nixpkgs.nix) { } }: rec {
  wrapWine = pkgs.callPackage ./wrapWine.nix { };
  kindle_1_17 = pkgs.callPackage ./wineApps/kindle.nix {
    inherit wrapWine;
  };
  webcam-segmentation = pkgs.fetchFromGitHub {
    owner = "TroyNeubauer";
    repo = "webcam-segmentation";
    rev = "3607f3eec2a6d58d15ec7b0f82822133acfa4bab";
    hash = "sha256-w+IZ4T63/WNl9TpiCwHiAVY43XDF5ilF8pZMcV0P5/o=";
  };
  # TODO: FIXME
  # openvsp = pkgs.callPackage ./open-vsp.nix { };
  foxglove = pkgs.callPackage ./foxglove.nix { };
}
