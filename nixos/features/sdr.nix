{ config, pkgs, callPackage, ... }:
{
  environment.systemPackages = with pkgs; [
    hackrf
    libbladeRF
    usbutils
  ];

  hardware.hackrf.enable = true;
  hardware.bladeRF.enable = true;
  hardware.rtl-sdr.enable = true;
}
