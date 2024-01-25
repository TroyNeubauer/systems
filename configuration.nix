{ config, pkgs, callPackage, ... }:
{
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
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
    ripgrep
    tree
    wireguard-tools
  ];

  programs.neovim.defaultEditor = true;

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
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      libGL
    ];
    setLdLibraryPath = true;
  };

  sound.enable = true;
  # TODO: switch to jack
  hardware.pulseaudio.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

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
      noto-fonts
      noto-fonts-extra
    ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowPing = true; 

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.222.0.3/24" ];
      listenPort = 51820;

      privateKeyFile = "/etc/secrets/wg-private";

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

  # Virtualisation
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "troy" ];

  system.stateVersion = "23.05";
}
