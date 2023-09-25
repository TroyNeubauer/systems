{
  username,
  pkgs,
  home-manager,
  ...
}:

{
  home.packages = with pkgs; [
    htop
    #  pkgs.qbittorrent
  ];

  # darwin.installApps = true;
  # darwin.fullCopies = true;
  # programs.firefox = nur-no-pkgs.repos.toonn.apps.firefox;
}
