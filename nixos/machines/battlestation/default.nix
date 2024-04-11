{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix

    ../../features/sound.nix
    ../../features/kindle
    ../../features/bluetooth.nix
    ../../features/i3/default.nix
    ../../features/virtualbox.nix
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.wrapOBS { plugins = [ obs-studio-plugins.obs-backgroundremoval ]; })
  ];

  home-manager.users.troy = import ../../../home/machines/battlestation.nix;

  networking.hostName = "battlestation";

  # Workaround for the igc driver segfaulting due to motherboard power management on ASUS ROG strix B650E-F
  # See: https://www.reddit.com/r/buildapc/comments/xypn1m/network_card_intel_ethernet_controller_i225v_igc/
  boot.kernelParams = [ "pcie_port_pm=off" "pcie_aspm.policy=performance" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
  networking.networkmanager.enable = true;

  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      libGL
    ];
    setLdLibraryPath = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    extraConfig = ''ListenAddress = 10.222.0.3'';
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  services.photoprism = {
    enable = true;
    port = 2342;
    originalsPath = "/var/lib/private/photoprism/originals";
    address = "10.222.0.3";
    settings = {
      PHOTOPRISM_ADMIN_USER = "admin";
      PHOTOPRISM_ADMIN_PASSWORD = "admin";
      PHOTOPRISM_DEFAULT_LOCALE = "en";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
      PHOTOPRISM_SITE_URL = "http://photos.tneubauer.xyz";
      PHOTOPRISM_SITE_TITLE = "My PhotoPrism";
    };
  };

  services.mysql = {
    enable = true;
    dataDir = "/data/mysql";
    package = pkgs.mariadb;
    ensureDatabases = [ "photoprism" ];
    ensureUsers = [ {
      name = "photoprism";
      ensurePermissions = {
        "photoprism.*" = "ALL PRIVILEGES";
      };
    } ];
  };

  networking.firewall.enable = false;
  # networking.firewall.allowedUDPPorts = [ 51820 ];
  # networking.firewall.allowedTCPPorts = [ 4567 ];
  # networking.firewall.allowPing = true;

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.222.0.3/24" ];
      listenPort = 51820;

      privateKeyFile = "/etc/secrets/wg-private";
      # publicKey = "SPZtxJdmrFdmQWHimhoFXBoCMk2f34KMClFVkBU=";

      peers = [
        {
          publicKey = "RghT14Gj3wFDWhtpYP+eC1xOSnWB2hKnpx23ZsEn3Gs=";

          # Forward subnet
          allowedIPs = [ "10.222.0.0/24" ];

          endpoint = "45.86.230.190:51820";
          persistentKeepalive = 25;
        }

        # {
        #   publicKey = "yrcEn4vUE5Tz7iLwjcsqCOz1HU0MH30YZBb0R79gPDo=";

        #   # Forward subnet
        #   allowedIPs = [ "10.222.0.7/32" ];

        #   endpoint = "10.222.0.3:51820";
        #   persistentKeepalive = 25;
        # }
      ];
    };
  };
  
  system.stateVersion = "23.05";
}
