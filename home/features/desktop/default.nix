{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./flameshot.nix
    ./obs-studio.nix
  ];

  packages = with pkgs; [
    discord
    vlc
    # nvtop
    libreoffice-qt
    spotify
    qbittorrent
  ];
}
