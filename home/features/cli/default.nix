{ config, pkgs, ... }:
  let is_linux = pkgs.stdenv.isLinux;
in {
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
    delta
    eza
    fd
    fish
    nix-your-shell
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
    tree
    unzip
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    gdb
  ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
    lldb
  ];

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
  '';

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # TODO: add `dev` command that adds gc root to nix develop default shell and opens it
  # See: https://github.com/ruuda/dotfiles/blob/1a28049980c61f22706b2d5d3e8f8951527403a3/zsh/.zshrc#L142-L158
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      nix-your-shell fish | source
    '';
    plugins = [ ];
  };
}
