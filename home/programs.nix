{
  pkgs,
  username,
  ...
}: 
{
  home.packages = with pkgs; [
    alacritty
    eza
    fish
    # discord
    delta
    firefox
    fzf
    git
    htop
    hunspell
    hunspellDicts.en_US
    libreoffice-qt
    pavucontrol
    rustup
    gcc
    unzip
    # spotify
  ];

  programs = {
    git = {
      enable = true;
      delta.enable = true;
      userName = "Troy Neubauer";
      userEmail = "troyneubauer@gmail.com";
      extraConfig = {
        color = {
          ui = "auto";
        };
        commit = {
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
  };
}
