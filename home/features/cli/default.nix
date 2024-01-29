{ config, pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./nvim
  ];


    alacritty
    davinci-resolve
    firefox
    flameshot
    libreoffice-qt
    obs-studio
    qbittorrent

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
    vlc
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
