{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global 
  ];

  home.packages = with pkgs; [
    discord
    spotify
  ];
}
