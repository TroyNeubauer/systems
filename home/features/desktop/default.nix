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
    unstable.qbittorrent
    xclip
  ];

  programs.firefox.enable = true;

  services.flameshot.enable = true;
}
