{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global.nix
    ../features/desktop
  ];

  home.packages = with pkgs; [
    sdrpp
    unstable.davinci-resolve-studio
    local-pkgs.webcam-segmentation
    discord
    spotify
    nvtopPackages.full
  ];

  home.file.".config/i3/config".source = import ../../nixos/features/i3/config.nix {
    inherit (pkgs) writeText writeShellScript alacritty firefox rofi pavucontrol blueman;
    enforceDuo = true;
  };

  # Let home manager manage itself
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
