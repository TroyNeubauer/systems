{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    delta.enable = true;

    userName = "Troy Neubauer";
    userEmail = "troyneubauer@gmail.com";

    extraConfig = {
      color = {
        ui = "auto";
      };
      commit = {
        # TODO: re-setup signing keys
        # gpgsign = true;
      };
      core = {
        excludesfile = "~/.gitignore";
      };
      github = {
        user = "troyneubauer";
      };
      init = {
        defaultBranch = "master";
      };
      pull = {
        rebase = false;
      };
      push = {
        default = "current";
        autoSetupRemote = true;
      };
    };
  };
}
