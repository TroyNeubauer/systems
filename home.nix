{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "troy";
  home.homeDirectory = "/home/troy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    alacritty
    eza
    discord
    delta
    firefox
    htop
    hunspell
    hunspellDicts.en_US
    libreoffice-qt
    pavucontrol
    rustup
    unzip
    spotify
  ];

  # programs.neovim = import ./programs/neovim (config, pkgs);
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins;
      let
        
      in [
	nvim-cmp
	cmp-buffer
	cmp-path
	cmp-nvim-lua
	cmp-nvim-lsp

	luasnip
	friendly-snippets
	nvim-treesitter-parsers.rust
        # gruvbox-community
        # vim-airline
	# nvim-cmp
	# lsp-zero
        # telescope-nvim
      ]; # Only loaded if programs.neovim.extraConfig is set
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".config/nvim/init.lua".source = config.lib.file.mkOutOfStoreSymlink ./dotfiles/nvim/init.lua;
    ".config/nvim/init.lua".source = ./dotfiles/nvim/init.lua;
    ".config/nvim/lua/misc.lua".source = ./dotfiles/nvim/lua/misc.lua;
    ".config/nvim/lua/remap.lua".source = ./dotfiles/nvim/lua/remap.lua;
    ".config/nvim/after/plugin/lsp.lua".source = ./dotfiles/nvim/after/plugin/lsp.lua;
    ".config/.gitconfig".source = ./dotfiles/.gitconfig;
    
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
