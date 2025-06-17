# enables i3 tiling X11 window manager
# see home-manager config for all the interesting config bits
{ lib, pkgs, ...}:
{
  services.libinput.enable = true;
  services.displayManager.defaultSession = "none+i3";

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
      Xft.dpi: 160
    EOF
  '';

  services.xserver = {
    enable = true;

    xkb.layout = "us";
    xkb.variant = "dvp";
    xkb.options = "altwin:swap_alt_win";

    desktopManager.xterm.enable = false;

    excludePackages = [ pkgs.xterm ]; 

    windowManager.i3 = {
      enable = true;

      extraPackages = with pkgs; [
        alacritty
        rofi
        i3status
        i3lock
      ];
    };
  };
}
