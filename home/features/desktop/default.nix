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
    discord
    vlc
    # nvtop
    libreoffice-qt
    obs-studio
    qbittorrent
    spotify
  ];
}
