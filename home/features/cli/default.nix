{ config, pkgs, ... }:
  let is_linux = pkgs.stdenv.isLinux;
in {
  imports = [
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

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
  '';


  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      # if status is-interactive
      #   bash -c "nohup VBoxManage startvm 6201-mc --type headless > /dev/null 2>&1  || true" &; disown
      # end
    '';
    plugins = [ ];
  };
}
