{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    delta.enable = true;

    userName = "Troy Neubauer";
    userEmail = "troyneubauer@gmail.com";

    aliases = {
      set-upstream = "!git branch --set-upstream-to=origin/`${pkgs.git}/bin/git symbolic-ref --short HEAD`";
      amend = "commit -a --amend";
    };
    extraConfig = {
      color = {
        ui = "auto";
      };
      commit = {
        # TODO: re-setup signing keys
        # gpgsign = true;
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
