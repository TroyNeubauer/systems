{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../minimal.nix
  ];

  boot.loader.grub.enable = true;
  # Bluevps only supports legacy boot
  boot.loader.grub.efiSupport = false;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "tneubauerxyz"; 
  networking.networkmanager.enable = true;

  # ========== Server hosts ==========
  services.nginx = {
    enable = true;
  
    virtualHosts."tneubauer.xyz" = {
      forceSSL = true;
      enableACME = true;
      root = "/www/troy/public";
    };
    virtualHosts."www.tneubauer.xyz" = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "tneubauer.xyz";
    };
  
    virtualHosts."jcaiola.com" = {
      forceSSL = true;
      enableACME = true;
      root = "/www/jack/public";
    };

    virtualHosts."www.jcaiola.com" = {
      enableACME = true;
      forceSSL = true;
      globalRedirect = "jcaiola.com";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "neubauertroy@gmail.com";

    certs."tneubauer.xyz".extraDomainNames = [
      "www.tneubauer.xyz"
    ];
    certs."jcaiola.com".extraDomainNames = [
      "www.jcaiola.com"
    ];
  };

  # ========== SSH + Wireguard ==========
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    extraConfig = ''ListenAddress = 10.222.0.1'';
  };

  networking.firewall.enable = false;
  boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = "1";

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "ens3";
    internalInterfaces = [ "wg0" ];
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.222.0.1/24" ];
      listenPort = 51820;

      privateKeyFile = "/etc/secrets/wg-private";

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.222.0.0/24 -o ens3 -j MASQUERADE
      '';

      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.222.0.0/24 -o ens3 -j MASQUERADE
      '';

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
          ## Hamono (Macbook air m2 2023 asahi)
          publicKey = "5oDw9s63pCADEHsMoL/MlYkJzzTGveuR+n+0CVWU8Ts=";
          allowedIPs = [ "10.222.0.6/32" ];
        }
        {
          ## Battlestation windows
          publicKey = "yXCI+SBuoxFLG3Qa9FnGunA60VzwOwDUTQlxYRCh2DE=";
          allowedIPs = [ "10.222.0.8/32" ];
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
