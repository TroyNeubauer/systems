{ config, pkgs, ... }:
{
  home-manager.useGlobalPkgs = false;
  home-manager.useUserPackages = true;
  home-manager.users.troyneubauer = import ../../../home/machines/troys-macbook-air.nix;
  
  environment.systemPackages = [ pkgs.fish pkgs.just ];
  environment.shells = [pkgs.fish];
  
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [ "troyneubauer" "root" "dgramop" ];
  
  programs.fish.enable = true;
  programs.zsh.enable = false;
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # Newer Nix installs create the nixbld group with GID 350 instead of 30000
  ids.gids.nixbld = 350;
  
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  users.users.troyneubauer = {
    name = "troyneubauer";
    home = "/Users/troyneubauer";

    shell = pkgs.fish; 
  };
}
