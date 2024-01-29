{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix

    ../../features/sound.nix
    ../../features/i3.nix
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

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowPing = true; 

  networking.wireguard.interfaces = {
    mc = {
      ips = [ "10.200.0.3/24" ];
      listenPort = 51821;

      privateKeyFile = "/etc/secrets/wg-private";

      peers = [
        {
          publicKey = "Oe1FRAKz2OeNEYm/EQHLYHVg+FioGW79OmvlGEh/a28=";

          # Forward subnet
          allowedIPs = [ "10.200.0.0/24" ];

          endpoint = "45.86.230.190:51821";
          persistentKeepalive = 25;
        }
      ];
    };
  };
  
  system.stateVersion = "23.05";
}
