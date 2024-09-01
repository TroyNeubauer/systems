{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global.nix 
  ];

  home.packages = with pkgs; [
    discord
    spotify
  ];
}
