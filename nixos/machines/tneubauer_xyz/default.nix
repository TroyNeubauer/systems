{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../common.nix
  ];

  boot.loader.grub.enable = true;
  # Bluevps only supports legacy boot
  boot.loader.grub.efiSupport = false;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "tneubauer_xyz"; 
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    tmux
    curl
    wget
    man
  ];

  # Server hosts
  services.nginx.enable = true;

  services.nginx.virtualHosts."tneubauer.xyz" = {
    addSSL = true;
    enableACME = true;
    root = "/www/troy/public";
  };
  services.nginx.virtualHosts."jcaiola.com" = {
    addSSL = true;
    enableACME = true;
    root = "/www/jack/public";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "neubauertroy@gmail.com";
  };

  # SSH + Wireguard
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.enable = false;

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.222.0.1/24" ];
      listenPort = 51820;

      privateKeyFile = "/etc/secrets/wg-private";

      peers = [
        # Personal stuff
        {
          ## Old desktop
          publicKey = "QOfraTWg/GebA8qTjqQbYZV3RDWCc9suwtQNpqFbQnc=";
          allowedIPs = [ "10.222.0.2/32" ];
        }
        {
          ## Battlestation
          publicKey = "SPZtxJdmrFdmQWHimhoxRhOFXBoCMk2f34KMClFVkBU=";
          allowedIPs = [ "10.222.0.3/32" ];
        }
        {
          ## Laptop
          publicKey = "ll9vveK+8FAIg7vQNqIop34P7nYvjtwo6W5MnBUNJyU=";
          allowedIPs = [ "10.222.0.4/32" ];
        }
        {
          ## Macbook air m2 2023 macos
          publicKey = "hMF6qHQYPKSHwWOmdz20Uf5M1Ns7JgAO8D5ntyqJ9Q0=";
          allowedIPs = [ "10.222.0.5/32" ];
        }
        {
          ## Macbook air m2 2023 asahi
          publicKey = "5oDw9s63pCADEHsMoL/MlYkJzzTGveuR+n+0CVWU8Ts=";
          allowedIPs = [ "10.222.0.6/32" ];
        }
        {
          ## Jack's SUPERBRICK VM
          publicKey = "jBGMO8ttzqqRjeEI9x0kBg1Hl5CvdTzmwImbyAbmxgQ=";
          allowedIPs = [ "10.222.0.99/32" ];
        }
        # Merchguard
        {
          ## Dhruv m1 mac pro
          publicKey = "yrcEn4vUE5Tz7iLwjcsqCOz1HU0MH30YZBb0R79gPDo=";
          allowedIPs = [ "10.222.0.7/32" ];
        }
        ## Android terminal tablets
        {
          ### T1
          publicKey = "ZWEpvZ7OYfZHcX7w6hUZi+myh4DCNniZPqYiry96knQ=";
          allowedIPs = [ "10.222.0.20/32" ];
        }
        {
          ### T2
          publicKey = "UnMXy/SHOI1wKuqXBf2vi/NWXRUrAg3dblDyXSi86EQ=";
          allowedIPs = [ "10.222.0.21/32" ];
        }
      ];
    };
  };

  system.stateVersion = "23.11";
}
