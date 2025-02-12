{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ../global.nix
    ../features/desktop/alacritty.nix
  ];

  home.packages = with pkgs; [
    sdrpp
  ];

  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
