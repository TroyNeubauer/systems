{ config, pkgs, lib, ... }:
let
  # TODO: Add as input argument, so we can easily disable, or have separate duo-orented module that can be optionally added
  enforceDuo = true;
  enforceDuoScript = pkgs.writeShellScript "enforce-duo" ''
    if [ -f /tmp/.computer_unblocked ]; then
      echo allowed RUNNING: "$1"
      eval "$1"
    else
      echo BLOCKED RUNNING: "$2"
      eval "$2"
    fi
  '';

  launchDuoFirefox = pkgs.writeShellScript "launch-duo-firefox" ''
    "${pkgs.firefox}/bin/firefox" \
      --new-tab https://duolingo.com \
      --new-tab http://127.0.0.1:4550/
  '';
in {

  wayland.windowManager.sway = {
    enable = true;
    extraOptions = [ "--unsupported-gpu" ];

    config = rec {
      modifier = "Mod1";
      floating.modifier = "Mod1";
      fonts = [ "pango:monospace 11" ];
      terminal = "${pkgs.alacritty}/bin/alacritty";
      menu = "${pkgs.walker}/bin/walker";

      input = {
        "*" = {
          xkb_layout  = "us";
          xkb_variant = "dvp";
        };
      };

      output = {
        "DP-0"   = {
          mode      = "1920x1080";
          position  = "0 845";
          transform = "normal";
        };
        "DP-2" = {
          mode      = "3840x2160";
          position  = "1920 0";
          transform = "normal";
        };
      };

      keybindings = lib.mkOptionDefault {
        # Alt+Enter → Duo-aware terminal
        "${modifier}+Return" =
          if enforceDuo
          then "${enforceDuoScript} ${pkgs.alacritty}/bin/alacritty ${launchDuoFirefox}"
          else "${pkgs.alacritty}/bin/alacritty";

        # Alt+d → walker (or open Duo if still blocked)
        "${modifier}+d" =
          if enforceDuo
          then "${enforceDuoScript} ${pkgs.walker}/bin/walker ${launchDuoFirefox}"
          else "${pkgs.walker}/bin/walker";
      };

      startup = [
        # { command = "dex --autostart --environment sway"; always = false; }
        # Duolingo stuff 
      ] ++ lib.optionals enforceDuo [
        { command = "firefox --new-tab https://duolingo.com --new-tab http://127.0.0.1:4550/"; always = false; }
        { command = "pavucontrol"; always = false; }
        { command = "blueman-manager"; always = false; }
      ];
    };
  };
}
