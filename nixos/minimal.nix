# Baseline "minimal" config, suitable for headless boxes (router, raspberry pi, etc)
# Most hosts extend from ./common.nix instead, which includes quality of life stuff
# like fonts, podman, etc.

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./users.nix
  ];

  time.timeZone = lib.mkDefault "America/New_York";

  home-manager.extraSpecialArgs = { inherit inputs outputs; };

  programs.fish.enable = true;
  services.openssh.enable = true;

  environment.shells = with pkgs; [ fish ];

  environment.systemPackages = with pkgs; [
    curl
    file
    fish
    git
    htop
    python3
    ripgrep
    tree
    wireguard-tools
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix = {

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    package = pkgs.nixFlakes;
  };

  services.automatic-timezoned.enable = lib.mkDefault false;

  # The rest of the configuration is set by each host config, which will
  # import this file and extend to suit each host.
}
