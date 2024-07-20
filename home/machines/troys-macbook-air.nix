{ inputs, outputs, lib, pkgs, config, ... }:
# let cli = import ../features/cli { config=config; pkgs=pkgs; lib=lib; };
{
  imports = [
    ../features/cli
  ];

#  home.packages = with pkgs; lib.mkMerge [
#    cli.packages
#    [
#      # discord
#      # spotify
#    ]
#  ];

  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
