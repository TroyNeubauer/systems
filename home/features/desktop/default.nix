{ config, pkgs, lib, ... }:
{
  imports = [
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    audacity
    gimp
    firefox
    flameshot
    vlc
    # nvtop
    libreoffice-qt
    qbittorrent
  ];

  programs.firefox.enable = true;

  services.flameshot.enable = true;
}
