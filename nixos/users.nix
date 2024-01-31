{ config, pkgs, ... }:
{
  users.users.troy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" "docker" "systemd-journal" ];

    shell = pkgs.fish; 
  };

  # allow running nixos-rebuild as root without a password.
  # requires us to explicitly pull in nixos-rebuild from pkgs, so
  # we get the right path in the sudo config
  environment.systemPackages = [ pkgs.nixos-rebuild ];
  security.sudo.extraRules = [
    {  users = [ "troy" ];
      commands = [
        { command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = [ "NOPASSWD" "SETENV" ];
        }
        { command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" "SETENV" ];
        }
        { command = "${pkgs.systemd}/bin/systemctl";
          options = [ "NOPASSWD" "SETENV" ];
        }
        # reboot and shutdown are symlinks to systemctl,
        # but need to be authorized in addition to the systemctl binary
        # to allow nopasswd sudo
        { command = "/run/current-system/sw/bin/shutdown";
          options = [ "NOPASSWD" "SETENV" ];
        }
        { command = "/run/current-system/sw/bin/reboot";
          options = [ "NOPASSWD" "SETENV" ];
        }           
      ];
    }
  ];
}
