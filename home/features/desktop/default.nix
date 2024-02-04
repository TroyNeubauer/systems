{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    alacritty
    discord
    firefox
    vlc
    flameshot
    # nvtop
    libreoffice-qt
    spotify
    obs-studio
    qbittorrent

    # pkgs.unstable.davinci-resolve
  ];
}
