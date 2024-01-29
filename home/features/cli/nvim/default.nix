{ config, pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      fzf
      rust-analyzer
    ];

    plugins = with pkgs.vimPlugins; [
      # nvim-lspconfig
      vim-nix
      nvim-treesitter.withAllGrammars
      plenary-nvim 
      gruvbox-nvim
      luasnip

      lsp-zero-nvim
      nvim-cmp
      cmp_luasnip
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-spell

      lualine-nvim
      lualine-lsp-progress
      telescope-zf-native-nvim
      telescope-nvim
    ];
  };

  home.file = { 
    ".config/nvim/init.lua".source = ./init.lua;
    ".config/nvim/lua/line.lua".source = ./lua/line.lua;
    ".config/nvim/lua/lsp.lua".source = ./lua/lsp.lua;
    ".config/nvim/lua/misc.lua".source = ./lua/misc.lua;
    ".config/nvim/lua/remap.lua".source = ./lua/remap.lua;
  };
}
