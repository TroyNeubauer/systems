{ config, pkgs, ... }:
  let is_linux = pkgs.stdenv.isLinux;
in {
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
    # Not supported on m2, need to dynamically add here
    # [if is_linux then [gdb] else []]
    fd
    fish
    ffmpeg
    lldb
    git
    jq
    htop
    hunspell
    hunspellDicts.en_US
    mold
    p7zip
    rustup
    tmux
    tree
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
