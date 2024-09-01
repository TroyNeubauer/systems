{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global.nix 
  ];

  home.packages = with pkgs; [
    unstable.davinci-resolve-studio
    local-pkgs.webcam-segmentation
    discord
    spotify
    nvtopPackages.full
  ];
}
