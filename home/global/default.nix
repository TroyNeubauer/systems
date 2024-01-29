{ inputs, outputs, lib, config, pkgs, ... }: 
let
  inherit (pkgs.stdenv) isDarwin;
  homeDirectory = if isDarwin then "/Users/troy" else "/home/troy";
in
{
  imports = [
    ../features/cli
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "troy";
    inherit homeDirectory;
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = lib.mkDefault "alacritty";
      COLORTERM = lib.mkDefault "truecolor";
      BROWSER = lib.mkDefault "firefox";
    };
  };

  # Let home manager manage itself
  programs.home-manager.enable = true;

  # systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
