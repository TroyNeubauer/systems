# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, apple-silicon, ... }:
{
  imports = [
    apple-silicon.nixosModules.apple-silicon-support
  ];

  nixpkgs.overlays = [ apple-silicon.overlays.apple-silicon-overlay ];
  hardware.asahi.useExperimentalGPUDriver = true;

  programs.light.enable = true;

  networking.hostName = "hamono";

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = false;

  # TODO: remove once we get x86_64 builder is required
  hardware.asahi.pkgsSystem = "x86_64-linux";

  # Specify path to peripheral firmware files
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
}
