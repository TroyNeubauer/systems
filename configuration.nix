# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

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
  time.timeZone = "America/NewYork";

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
    file
    fish
    git
    htop
    neovim
    nvtop
    python3
    plymouth
    tree
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

  system.stateVersion = "23.05"; # Did you read the comment?
}

