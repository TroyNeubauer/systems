{ config, pkgs, ... }:
{
  imports = [
    ./cargo.nix
    ./fish.nix
    ./git.nix
    ./nvim
  ];


  home.packages = with pkgs; [
    eza
    clang
    clang-tools
    delta
    fd
    fish
    ffmpeg
    git
    jq
    htop
    hunspell
    hunspellDicts.en_US
    mold
    p7zip
    rustup
    tmux
    unzip
  ];

  programs = {
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # nixpkgs.config = import ./nixpkgs-config.nix;
  # home.file."nixpkgs-config" = {
  #   target = ".config/nixpkgs/config.nix";
  #   source = ./nixpkgs-config.nix;
  # };
  
}
