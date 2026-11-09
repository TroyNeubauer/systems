{ config, pkgs, ... }:
{
  imports = [
    ./git.nix
    ./nvim
  ];

  home.packages = with pkgs; [
    cargo-machete
    cargo-public-api
    cargo-expand
    clang
    clang-tools
    eza
    fd
    nix-your-shell
    ffmpeg
    git
    gh
    jq
    hex
    htop
    hunspell
    hunspellDicts.en_US
    mold
    p7zip
    tmux
    tokei
    tree
    unzip
    (rust-bin.stable.latest.default.override { extensions = [ "rust-src" "rust-analyzer" ]; })
  ] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    gdb
  ] ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
    lldb
  ];

  programs = {
    fzf.enable = true;
    fzf.enableFishIntegration = true;

    # TODO: add `dev` command that adds gc root to nix develop default shell and opens it
    # See: https://github.com/ruuda/dotfiles/blob/1a28049980c61f22706b2d5d3e8f8951527403a3/zsh/.zshrc#L142-L158
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting

        nix-your-shell fish | source
      '';
      plugins = [ ];
    };
  };
}
