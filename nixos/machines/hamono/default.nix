{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
    ../../common.nix

    ../../features/sound.nix
    ../../features/i3/default.nix
  ];

  home-manager.users.troy = import ../../../home/machines/hamono.nix;

  networking.hostName = "hamono";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
 
  networking.networkmanager.enable = true;

  services.xserver.dpi = 140;

  nixpkgs.overlays = [ inputs.apple-silicon.overlays.apple-silicon-overlay ];

  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.experimentalGPUInstallMode = "replace";
  hardware.asahi.setupAsahiSound = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    extraConfig = ''ListenAddress = 10.222.0.6'';
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowPing = true; 

  networking.wireguard.interfaces = {
    troy = {
      ips = [ "10.222.0.6/24" ];
      listenPort = 51820;

      privateKeyFile = "/etc/secrets/wg-private";
      # publicKey = "5oDw9s63pCADEHsMoL/MlYkJzzTGveuR+n+0CVWU8Ts=";

      peers = [
        {
          publicKey = "RghT14Gj3wFDWhtpYP+eC1xOSnWB2hKnpx23ZsEn3Gs=";

          # Forward subnet
          allowedIPs = [ "10.222.0.0/24" ];

          endpoint = "45.86.230.190:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
  
  system.stateVersion = "23.05";
}
