# Extends minimal config to include features we almost always want (fonts, etc.) 
{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./minimal.nix

    ./features/fonts.nix
  ];
}
