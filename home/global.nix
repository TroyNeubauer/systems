{ inputs, outputs, lib, config, pkgs, ... }: 
let
  inherit (pkgs.stdenv) isDarwin;
  # TODO: make generic
  username = "tneubauer";
  homeDirectory = if isDarwin then "/Users/troy" else "/home/${username}";
in
{
  imports = [
    features/cli
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
    inherit username;
    inherit homeDirectory;
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = lib.mkDefault "alacritty";
      COLORTERM = lib.mkDefault "truecolor";
      BROWSER = lib.mkDefault "firefox";
    };
  };

  home.file.".config/i3/config".source = import ../nixos/features/i3/config.nix {
    inherit (pkgs) writeText;
    alacritty = "alacritty";
  };
}
