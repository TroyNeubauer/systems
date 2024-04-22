{ inputs, outputs, lib, pkgs, config, ... }:
let global = import ../features/desktop { config=config; pkgs=pkgs; lib=lib; };
in {
  imports = [
    ../global 
  ];

  home.packages = with pkgs; lib.mkMerge [
    global.packages
    [
      pkgs.unstable.davinci-resolve
      pkgs.local-pkgs.webcam-segmentation
      discord
      spotify
      nvtopPackages.full
    ]
  ];
}
