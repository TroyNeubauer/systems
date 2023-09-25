{
  pkgs,
  username,
  ...
}: 
{

  home.packages = with pkgs; [
    htop
    alacritty
    fish
    fzf
    git
  ];

  programs = {
    git = {
      enable = true;
      delta.enable = true;
      userName = "Troy Neubauer";
      extraConfig = {
        color = {
          ui = "auto";
        };
        commit = {
          gpgsign = true;
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
  };
}
