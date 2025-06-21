{ inputs, outputs, lib, pkgs, config, ... }:
{
  imports = [
    ../global.nix
    ../features/desktop
    # TODO: fix
    # ../features/sway
  ];

  home.packages = with pkgs; [
    sdrpp
    unstable.davinci-resolve-studio
    local-pkgs.webcam-segmentation
    discord
    spotify
    nvtopPackages.full
    local-pkgs.openvsp
    local-pkgs.foxglove
  ];

  home.file.".config/i3/config".source = import ../../nixos/features/i3/config.nix {
    inherit (pkgs) writeText writeShellScript alacritty firefox rofi pavucontrol blueman;
    enforceDuo = true;
  };

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
  '';

  # Let home manager manage itself
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
