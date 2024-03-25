{ lib, pkgs, config, ... }:
let alacritty_themes = lib.fetchFromGithub {
  owner = "alacritty";
  repo = "alacritty-theme";
  rev = "c2369cd1ec555c8dba7ea39bd059b7c036f1e637";
};
in {
  programs.alacritty = {
    enable = true;

    settings = ''
      [font.normal]
        family: Jetbrains Mono
        size = 13;
      live_config_reload: true

    '';
      # ${alacritty_themes}/themes/catppuccin_mocha.toml
  };
}
