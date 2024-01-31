# enables i3 tiling X11 window manager
# see home-manager config for all the interesting config bits
{ lib, pkgs, ...}:
{
  services.xserver = {
    enable = true;
    libinput.enable = true;

    layout = "us";
    xkbVariant = "dvp";
    xkbOptions = "altwin:swap_alt_win";

    desktopManager.xterm.enable = false;

    excludePackages = [ pkgs.xterm ]; 

    displayManager.defaultSession = "none+i3";

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
