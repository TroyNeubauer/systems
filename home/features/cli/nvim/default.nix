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
      vim-gitgutter
    ];
  };

  # We like to symlink `~/.config/nvim/spell/en.utf-8.add` to point to `./en.utf-8.add`,
  # so that we can easily keep our additions in version control. Nix doesn't like this since its not pure.
  # When setting up a new system run (assuming this project is in `~/nix/systems`:
  # `rm -f ~/.config/nvim/spell/en.utf-8.add && ln -s ~/nix/systems/home/features/cli/nvim/en.utf-8.add ~/.config/nvim/spell/en.utf-8.add`
  # TODO: do this automatically

  home.file = { 
    ".config/nvim/init.lua".source = ./init.lua;
    ".config/nvim/lua/line.lua".source = ./lua/line.lua;
    ".config/nvim/lua/lsp.lua".source = ./lua/lsp.lua;
    ".config/nvim/lua/misc.lua".source = ./lua/misc.lua;
    ".config/nvim/lua/remap.lua".source = ./lua/remap.lua;
  };
}
