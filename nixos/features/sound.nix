{ pkgs, ... }:
{
  # disable default sound module. see https://nixos.wiki/wiki/PipeWire
  sound.enable = false;
  hardware.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
  };

  environment.systemPackages = builtins.attrValues { inherit (pkgs) pavucontrol alsa-utils; };
}
