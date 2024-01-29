{ config, pkgs, callPackage, ... }:
{
  # Virtualisation
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "troy" ];
}
