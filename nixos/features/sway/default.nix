{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard
    nwg-displays
    dunst
  ];

  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
