{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    audacity
    gimp
    vlc
    libreoffice-qt
    xclip
  ];

  programs.firefox.enable = true;

  services.flameshot.enable = true;
}
