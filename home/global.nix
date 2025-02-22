{ inputs, outputs, lib, config, pkgs, ... }: 
let
  # Fall back to builtins.currentSystem if nixpkgs.system is missing (nix darwin)
  system = config.nixpkgs.system or builtins.currentSystem;
  isDarwin = lib.strings.match ".*-darwin" system != null;
in
{
  imports = [
    features/cli
  ];

  nixpkgs = {
    overlays = [
      (import inputs.rust-overlay)
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
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = lib.mkDefault "alacritty";
      COLORTERM = lib.mkDefault "truecolor";
      BROWSER = lib.mkDefault "firefox";
    };
  } // lib.optionalAttrs (! isDarwin) {
    homeDirectory = "/home/troy";
    username = "troy";
  }; 
}
