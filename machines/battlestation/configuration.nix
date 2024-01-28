{ config, pkgs, ... }:
{

# Workaround for the igc driver segfaulting due to motherboard power management on ASUS ROG strix B650E-F
  # See: https://www.reddit.com/r/buildapc/comments/xypn1m/network_card_intel_ethernet_controller_i225v_igc/
  boot.kernelParams = [ "pcie_port_pm=off" "pcie_aspm.policy=performance" ];

  networking.hostName = "troy-battlestation";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    extraConfig = ''ListenAddress = 10.222.0.3'';
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

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
}
