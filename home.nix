{ username,
  homeDirectory,
  stateVersion,
  pkgs,
  nixpkgs,
  home-manager,
  ...
}: {
  home = { inherit username homeDirectory stateVersion; };
}
