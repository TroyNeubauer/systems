{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.apple-silicon.nixosModules.apple-silicon-support
    ../../common.nix

    ../../features/sound.nix
    ../../features/i3.nix
  ];

  home-manager.users.troy = import ../../../home/machines/hamono.nix;

  networking.hostName = "hamono";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
 
  networking.networkmanager.enable = true;

  # services.openssh = {
  #   enable = true;
  #   settings.PasswordAuthentication = true;
  #   # extraConfig = ''ListenAddress = 10.222.0.3'';
  # };

  # networking.firewall.allowedUDPPorts = [ 51820 ];
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowPing = true; 

  # networking.wireguard.interfaces = {
  #   mc = {
  #     ips = [ "10.200.0.3/24" ];
  #     listenPort = 51821;

  #     privateKeyFile = "/etc/secrets/wg-private";

  #     peers = [
  #       {
  #         publicKey = "Oe1FRAKz2OeNEYm/EQHLYHVg+FioGW79OmvlGEh/a28=";

  #         # Forward subnet
  #         allowedIPs = [ "10.200.0.0/24" ];

  #         endpoint = "45.86.230.190:51821";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };
  
  system.stateVersion = "23.05";
}
