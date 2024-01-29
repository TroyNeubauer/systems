{
 pkgs,
  ...
}: 
{ 

  home.file = { 
    ".config/nvim/init.lua".source = ./dotfiles/nvim/init.lua;
    ".config/nvim/lua/line.lua".source = ./dotfiles/nvim/lua/line.lua;
    ".config/nvim/lua/lsp.lua".source = ./dotfiles/nvim/lua/lsp.lua;
    ".config/nvim/lua/misc.lua".source = ./dotfiles/nvim/lua/misc.lua;
    ".config/nvim/lua/remap.lua".source = ./dotfiles/nvim/lua/remap.lua;
    ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
    ".cargo/config.toml".text = ''
      [target.x86_64-unknown-linux-gnu]
      linker = "clang"
      rustflags = ["-C", "link-arg=-fuse-ld=${pkgs.mold}/bin/mold"]
    '';
  };

  programs = { 
    neovim = {
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

  };
}
