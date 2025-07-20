{ config, pkgs, callPackage, ... }:
{
  environment.systemPackages = with pkgs; [
    hackrf
    libbladeRF
    usbutils
    (gnuradio3_8.override {
      extraPackages = with gnuradio3_8Packages; [
        xterm
        osmosdr
        limesdr
        hackrf
        libbladeRF
      ];
      extraPythonPackages = with gnuradio3_8.python.pkgs; [
        numpy
      ];
    })
  ];

  hardware.hackrf.enable = true;
  hardware.bladeRF.enable = true;
  hardware.rtl-sdr.enable = true;
}
