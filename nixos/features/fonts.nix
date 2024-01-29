{ pkgs
, lib
, ...}:
let
  nerdFonts = [
    "FiraCode"
    "DroidSansMono"
    "JetBrainsMono"
    "FantasqueSansMono"
    "Iosevka"
  ];
in {
  # set the console font
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # accept the license for the Joypixels font
  nixpkgs.config.joypixels.acceptLicense = true;

  fonts = {
    fontconfig = {
      enable = lib.mkForce true;

      # TODO: test
      # defaultFonts = {
      #   serif = [ "Liberation Serif" "Joypixels" ];
      #   sansSerif = [ "SF Pro Display" "Joypixels" ];
      #   monospace = [ "FiraCode Nerd Font Mono" ];
      #   emoji = [ "Joypixels" ];
      # };

      # fix pixelation
      antialias = true;

      # fix antialiasing blur
      hinting = {
        enable = true;
        style = "full";
        autohint = true;
      };

      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;

    packages = [
      (pkgs.nerdfonts.override { fonts = nerdFonts; })
    ] ++ builtins.attrValues {
      inherit (pkgs)

      corefonts  # Micrsoft free fonts
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
      dejavu_fonts
      freefont_ttf
      liberation_ttf
      emojione
      open-fonts
      noto-fonts
      joypixels
      noto-fonts-extra
      ;
    };
  };
}
