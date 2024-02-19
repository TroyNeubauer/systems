{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./flameshot.nix
    ./obs-studio.nix
  ];

  home.packages = with pkgs; [
    discord
    vlc
    # nvtop
    libreoffice-qt
    spotify
    qbittorrent
    # pkgs.unstable.davinci-resolve
  ];
}
