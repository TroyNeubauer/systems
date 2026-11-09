{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global.nix
    ../features/desktop
  ];

  home.file.".config/i3/config".source = import ../../nixos/features/i3/config.nix {
    inherit (pkgs) writeText writeShellScript alacritty firefox rofi pavucontrol blueman wireplumber brightnessctl playerctl;
    enforceDuo = false;
  };

  # i3status's default battery module looks for BAT0/BAT1; Asahi exposes the battery as macsmc-battery
  programs.i3status = {
    enable = true;
    modules."battery all".enable = false;
    modules."battery 0" = {
      position = 4;
      settings = {
        path = "/sys/class/power_supply/macsmc-battery/uevent";
        format = "%status %percentage %remaining";
        last_full_capacity = true;
      };
    };
  };

  # Let home manager manage itself
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
