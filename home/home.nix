{ username,
  homeDirectory,
  stateVersion,
  pkgs,
  nixpkgs,
  home-manager,
  lib,
  ...
}:
{
imports =
  [
    # (import ./dotfiles.nix { inherit username pkgs; })
    (import ./programs.nix { inherit pkgs username; })
    # ./programs.nix
  ]
  ++ nixpkgs.lib.optionals pkgs.stdenv.isDarwin [
    (import ./mac.nix { inherit username pkgs home-manager; })
  ]
  ++ nixpkgs.lib.optionals pkgs.stdenv.isLinux [
    (import ./linux.nix { inherit home-manager pkgs; })
  ];

  home = { inherit username homeDirectory stateVersion; };

  # TODO: fix
  # Install MacOS applications to the user environment if the targetPlatform is Darwin
  # home.file."Applications/home-manager".source = let
  # apps = pkgs.buildEnv {
  #   name = "home-manager-applications";
  #   paths = home.packages;
  #   pathsToLink = "/Applications";
  # };
  # in mkIf pkgs.stdenv.targetPlatform.isDarwin "${apps}/Applications";

  programs.home-manager.enable = true;

}
