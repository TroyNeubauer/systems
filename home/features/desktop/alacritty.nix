{ config, pkgs, lib, ... }:
let
  alacritty_themes = pkgs.fetchFromGitHub {
    owner = "alacritty";
    repo = "alacritty-theme";
    rev = "c2369cd1ec555c8dba7ea39bd059b7c036f1e637";
    hash = "sha256-eCJ9CpKoBTaA684vDJ6p8IB2AhvIBfrrKuyoKCr1BJs=";
  };
in {
  programs.alacritty.enable = true;

  home.file.".config/alacritty/alacritty.toml".source = pkgs.writeText "alacritty.toml" ''
    font.size = 10
    shell.program = "${pkgs.fish}/bin/fish"

    # Autogenerated color theming:
    ${builtins.readFile "${alacritty_themes}/themes/alabaster_dark.toml"}
  '';
}
