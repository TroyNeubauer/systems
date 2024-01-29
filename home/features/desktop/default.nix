{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    alacritty
    davinci-resolve
    firefox
    vlc
    flameshot
    libreoffice-qt
    obs-studio
    qbittorrent
  ];
}
