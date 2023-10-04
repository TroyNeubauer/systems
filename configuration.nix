{ config, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "troy-battlestation";
  networking.networkmanager.enable = true;

  # Allow nvidia
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  users.users.troy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" "docker" "systemd-journal" ];
  };

  nixpkgs.config.firefox.speechSynthesisSupport = true;

  environment.systemPackages = with pkgs; [
    curl
    discord
    spotify
    file
    fish
    git
    htop
    neovim
    nvtop
    python3
    plymouth
    tree
    wireguard-tools
  ];

  services.xserver = {
    enable = true;

    layout = "us";
    xkbVariant = "dvp";
    xkbOptions = "altwin:swap_alt_win";

    desktopManager = {
      xterm.enable = false;
    };

    excludePackages = [ pkgs.xterm ]; 

    displayManager = {
      defaultSession = "none+i3";
    };

    videoDrivers = [ "nvidia" ];
    
    windowManager.i3 = {
      enable = true;

      extraPackages = with pkgs; [
        rofi
        i3status
	i3lock
      ];
    };
  };

  hardware.nvidia.nvidiaSettings = true;
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  sound.enable = true;
  # TODO: switch to jack
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;

  environment.shells = with pkgs; [ fish ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  fonts = {
    fontconfig = {
      enable = true;
    };
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      corefonts  # Micrsoft free fonts
      inconsolata  # monospaced
      ubuntu_font_family  # Ubuntu fonts
      unifont # some international languages
      dejavu_fonts
      freefont_ttf
      liberation_ttf
      emojione
    ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowPing = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    extraConfig = ''ListenAddress = 10.222.0.3'';
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.222.0.3/24" ];
      listenPort = 51820;

      privateKeyFile = "/etc/secrets/wg-battlestation-private";
      # publicKey = "SPZtxJdmrFdmQWHimhoxRhOFXBoCMk2f34KMClFVkBU=";

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

    mc = {
      ips = [ "10.200.0.3/24" ];
      listenPort = 51821;

      privateKeyFile = "/etc/secrets/wg-battlestation-private";

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

  # virtualisation
  # virtualisation.virtualbox.host.enable = true;
  # users.extraGroups.vboxusers.members = [ "troy" ];

  system.stateVersion = "23.05"; # Did you read the comment?
}

