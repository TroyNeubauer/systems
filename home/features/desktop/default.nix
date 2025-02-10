{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    audacity
    gimp
    flameshot
    vlc
    # nvtop
    libreoffice-qt
    qbittorrent
  ];

  programs.firefox.enable = true;

  services.flameshot.enable = true;
}
