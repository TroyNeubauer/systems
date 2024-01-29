{ config, pkgs, callPackage, ... }:
{
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "troy" ];
}
