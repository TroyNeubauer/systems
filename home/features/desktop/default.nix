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
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

  services.flameshot.enable = true;
}
