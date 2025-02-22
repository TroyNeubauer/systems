{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    delta.enable = true;

    userName = "Troy Neubauer";
    userEmail = lib.mkDefault "troyneubauer@gmail.com";

    aliases = {
      set-upstream = "!git branch --set-upstream-to=origin/`${pkgs.git}/bin/git symbolic-ref --short HEAD`";
      amend = "commit -a --amend";

      # From: https://stackoverflow.com/questions/1838873/visualizing-branch-topology-in-git/34467298#34467298
      lg = "lg1";
      lg1 = "lg1-specific --all";
      lg2 = "lg2-specific --all";
      lg3 = "lg3-specific --all";

      lg1-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      lg2-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
      lg3-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(committed: %cD)%C(reset) %C(auto)%d%C(reset)%n''          %C(white)%s%C(reset)%n''          %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'";
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
