{ config, pkgs, system, inputs, ... }:

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
    (inputs.nixvim.legacyPackages."${system}".makeNixvim {
      globals.mapleader = " ";

      extraConfigLua = ''
        -- Prevent rust-analyzer from hogging the lock file
        vim.fn.setenv("CARGO_TARGET_DIR", "/tmp/nvim-rust-target"..os.getenv("PWD"))
        vim.fn.setenv("CARGO_LOCKED", "")

        --Text rename
        vim.keymap.set("n", "<C-t>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
        
        vim.keymap.set("n", "<leader>l", "<C-o>")
        vim.keymap.set("n", "<leader><leader>", ":b#<CR>")
        -- noremap <leader>n :bnext<CR>
        -- noremap <leader>b :bprev<CR>
        
        -- close buffer
        vim.keymap.set("n", "<leader>e", ":bd<CR>")
        
        -- make Dvorak Programmer keys function like digits without shift
        vim.keymap.set("n", "[", "7")
        vim.keymap.set("n", "{", "5")
        vim.keymap.set("n", "}", "3")
        vim.keymap.set("n", "(", "1")
        vim.keymap.set("n", "=", "9")
        vim.keymap.set("n", "*", "0")
        vim.keymap.set("n", ")", "2")
        vim.keymap.set("n", "+", "4")
        vim.keymap.set("n", "]", "6")
        vim.keymap.set("n", "!", "8")
        
        -- disable arrow keys
        vim.keymap.set("i", "<Up>", "<Nop>")
        vim.keymap.set("i", "<Down>", "<Nop>")
        vim.keymap.set("i", "<Left>", "<Nop>")
        vim.keymap.set("i", "<Right>", "<Nop>")
        
        vim.keymap.set("n", "<Up>", "<Nop>")
        vim.keymap.set("n", "<Down>", "<Nop>")
        vim.keymap.set("n", "<Left>", "<Nop>")
        vim.keymap.set("n", "<Right>", "<Nop>")
        
        -- use kk and jj to perform escape
        vim.keymap.set("i", "kk", "<Esc>")
        vim.keymap.set("i", "jj", "<Esc>:w<CR>")
      '';


      colorschemes.gruvbox.enable = true;
      plugins.lightline.enable = true;
      plugins.treesitter.enable = true;

      plugins.lsp = {
        enable = true;
        servers.rust-analyzer.enable = true;
        onAttach = ''
          local opts = {buffer = bufnr, remap = false}

          vim.keymap.set("n", ",h", function() vim.lsp.buf.definition() end, opts)
          vim.keymap.set("n", ",d", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set("n", ",i", function() vim.lsp.buf.implementation() end, opts)
          vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
          vim.keymap.set("n", "<space>d", function() vim.lsp.buf.type_definition() end, opts)
          vim.keymap.set("n", ",t", function() vim.lsp.buf.rename() end, opts)
          vim.keymap.set("n", ",w", function() vim.lsp.buf.code_action() end, opts)
          vim.keymap.set("n", ",r", function() vim.lsp.buf.references() end, opts)
          vim.keymap.set("n", "<space>f", function() vim.lsp.buf.formatting() end, opts)

          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
          vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
          vim.keymap.set("n", ",n", function() vim.diagnostic.goto_next() end, opts)
          vim.keymap.set("n", ",d", function() vim.diagnostic.goto_prev() end, opts)
          vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
          vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
          vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
          vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        '';
      };

      plugins.cmp-nvim-lsp.enable = true;
      plugins.nvim-cmp.enable = true;
      plugins.cmp-path.enable = true;
      plugins.cmp-buffer.enable = true;
      plugins.cmp-nvim-lua.enable = true;
      plugins.crates-nvim.enable = true;
      plugins.telescope.enable = true;

      options = {
        number = true;
        relativenumber = true;

        expandtab = true;
	cmdheight = 1;
        shiftwidth = 4;
      };

    })
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

    ".gitconfig".source = ./dotfiles/.gitconfig;

    ".config/nvim/lua/remap.lua".source = ./dotfiles/nvim/lua/remap.lua;
    
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
