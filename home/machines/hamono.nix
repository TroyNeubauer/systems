{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global.nix
  ]; 

  # Let home manager manage itself
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
