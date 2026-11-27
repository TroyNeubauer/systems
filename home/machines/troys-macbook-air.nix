{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    ../global.nix
    ../features/desktop/alacritty.nix
  ];

  home.packages = with pkgs; [
  ];

  # Copy apps into ~/Applications/Home Manager Apps instead of symlinking the folder into the nix
  # store, so Finder/Spotlight/Dock can see them (default only for stateVersion >= 25.11)
  targets.darwin.linkApps.enable = false;
  targets.darwin.copyApps.enable = true;

  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
