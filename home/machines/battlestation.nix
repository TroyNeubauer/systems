{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global
    ../features/desktop
    # ../features/davinci-resolve
  ];

 # programs.davinci-resolve.enable = true;
}
