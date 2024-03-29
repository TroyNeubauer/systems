{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./flameshot.nix
    ./obs-studio.nix
  ];

  packages = with pkgs; [
    firefox
    flameshot
    vlc
    # nvtop
    libreoffice-qt
    qbittorrent
  ];
}
