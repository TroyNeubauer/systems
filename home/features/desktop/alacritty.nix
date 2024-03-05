{ lib, pkgs, config, ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      font.size = 13;

      colors = {
        draw_bold_text_with_bright_colors = false;

        primary = {
          background = "0x10100E";
          foreground = "0xC6C6C4";
        };

        normal = {
          black = "0x000000";
          red = "0xDC322f";
          green = "0x859900";
          yellow = "0xFFD700";
          blue = "0x0087BD";
          magenta = "0x9A4EAE";
          cyan = "0x20B2AA";
          white = "0xEEEEEE";
        };

        bright = {
          black = "0x696969";
          red = "0xFF2400";
          green = "0x03C03C";
          yellow = "0xFDFF00";
          blue = "0x007FFF";
          magenta = "0xFF1493";
          cyan = "0x00CCCC";
          white = "0xFFFAFA";
        };
      };

    };
  };
}