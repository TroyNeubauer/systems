{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix

    ../../features/sound.nix
    ../../features/virtualbox.nix
    ../../features/kindle
    ../../features/bluetooth.nix
    ../../features/i3
  ];

  environment.systemPackages = with pkgs; [
    (pkgs.wrapOBS { plugins = [ obs-studio-plugins.obs-backgroundremoval ]; })
    linuxKernel.packages.linux_zen.perf
    hackrf
    libbladeRF
    (gnuradio3_8.override {
      extraPackages = with gnuradio3_8Packages; [
        xterm
        osmosdr
        limesdr
      ];
      extraPythonPackages = with gnuradio3_8.python.pkgs; [
        numpy
      ];
    })
    pkgs.unstable.android-studio
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

  hardware.hackrf.enable = true;

  programs.adb.enable = true;

  programs.nix-ld.enable = true;

  # VNC
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "${pkgs.i3}/bin/i3";


  services.xserver.videoDrivers = [ "nvidia" ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    extraConfig = ''
      ListenAddress = 10.222.0.3
      ListenAddress = 10.111.0.4
    '';
  };

  # services.plex = {
  #   enable = true;
  #   openFirewall = true;
  # };

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
      PHOTOPRISM_SITE_URL = "http://tneubauer.xyz";
      PHOTOPRISM_SITE_TITLE = "My PhotoPrism";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."battlestation.com" = {
      enableACME = false;
      forceSSL = false;
      root = "/disks/2024_8tb/www/foxhunter/public/";
      extraConfig = ''
        index index.html;
        autoindex on;
      '';

      listenAddresses = [ "10.111.0.4" ]; 
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
          allowedIPs = [ "10.222.0.0/24" ];
          endpoint = "45.86.230.190:51820";
          persistentKeepalive = 25;
        }
      ];
    };

    foxhunter = {
      ips = [ "10.111.0.4/24" ];
      listenPort = 51821;

      privateKeyFile = "/etc/secrets/foxhunter-wg-private";
      # publicKey = "YMCTQK7BK1d7V1Rt/aVLPgOqOKYpb//f8ez6HXbpty0=";

      peers = [
        {
          publicKey = "3Z7PGFd8VsaSZnI/8aI6COKETIW5IHD+ew50DnlHRko=";
          allowedIPs = [ "10.111.0.0/24" ];
          endpoint = "147.182.239.30:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

 users.users.dgramop = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "disk" "systemd-journal" ];
    shell = pkgs.fish;
    hashedPassword = "$y$j9T$baKreEdRcVytXBsm2l4HX0$5QzMQBJuEeoSCqfjzyxOsDPhF52xfk2BhWqGYfx3x19";

    openssh.authorizedKeys.keys = [
      # Dhruv m1 pro macos
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCljmP0GXaGu97J/vOE5kvlKZt262sqx2ADiN0Glt5dMjiP4ubQLmC4vUr4rajV/n1JcTJzp12LSNmIVUQKLZgxLpwKhk7W7EAElT2rCMj6Yr1c2P5B34nGCyDYPjMWahupkZafLHze9zWxtkH+fHicH4GtOXMW4R9nZycwqtefAUsWBSbG023rYgzO9lUz8ZPb846CgwxWdtDoOdf15O58IrRfrWF3QKzWErli3OZ5K4cu70D55xCyGG9+Gpozf1u0kTF80jCb24TNr2CELEo8rqVXmJeVqA5LO1g5putLzzeTt8XL6tBjT2Wu0eQAAVOODee51QXCQ8dM29HaT7rbodeWEBrfAIY0V8FsjGQSpQv0VmcDzTyQH7Se29Pd6kPYP8M3VjPoTK+RMHSOdgTPY7iAgUo5c5qhs4DA3vXI+CgaEopL3AiKOtycYOhkMB/HGcQZiZ126BCRlr7exeM7d5/XQsNjhuLjyAnOxsWNA8DI0IvmRflakka2gVqEYRk= dgramop@Dhruvs-MacBook-Pro.local"
    ];
  };
  
  system.stateVersion = "23.05";
}
