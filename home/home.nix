{ 
  pkgs,
  ...
}:
{
  imports =
  [
    (import ./programs.nix { inherit pkgs; })
  ];
  # ++ nixpkgs.lib.optionals pkgs.stdenv.isDarwin [
  #   (import ./mac.nix { inherit username pkgs home-manager; })
  # ] 

  home.username = "troy";
  home.homeDirectory = "/home/troy";

  home.stateVersion = "23.05";

  # home = { inherit username homeDirectory stateVersion; };

  # TODO: fix
  # Install MacOS applications to the user environment if the targetPlatform is Darwin
  # home.file."Applications/home-manager".source = let
  # apps = pkgs.buildEnv {
  #   name = "home-manager-applications";
  #   paths = home.packages;
  #   pathsToLink = "/Applications";
  # };
  # in mkIf pkgs.stdenv.targetPlatform.isDarwin "${apps}/Applications";

  # Let home manager manage itself
  programs.home-manager.enable = true;
}
