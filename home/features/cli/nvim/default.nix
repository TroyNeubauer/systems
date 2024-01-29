{ config, pkgs, ...}:

{
  programs.nvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      gruvbox-material
      mini-nvim
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
