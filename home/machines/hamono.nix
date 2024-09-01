{ inputs, outputs, lib, pkgs, config, ... }:
#let global = import ../features/desktop { config=config; pkgs=pkgs; lib=lib; };
{
  imports = [
    ../global 
  ]; 
}
