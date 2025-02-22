{ config, pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraPackages = with pkgs; [
      fzf
      rust-analyzer
      kotlin-language-server
      xsel
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
      vim-rooter
    ];
  };

  # We like to symlink `~/.config/nvim/spell/en.utf-8.add` to point to `./en.utf-8.add`,
  # so that we can easily keep our spelling additions in version control. Nix doesn't like this since its not pure.
  # When setting up a new system run (assuming this project is in `~/nix/systems`:
  # `rm -f ~/.config/nvim/spell/en.utf-8.add && ln -s ~/nix/systems/home/features/cli/nvim/en.utf-8.add ~/.config/nvim/spell/en.utf-8.add`
  # TODO: do this automatically
  # Systemd service may work, but then we have to assume the user always clones this repo into ~/nix/systems, akward, so punting for now

  home.file.".config/nvim/init.lua".source = ./init.lua;
  home.file.".config/nvim/lua/line.lua".source = ./lua/line.lua;
  home.file.".config/nvim/lua/lsp.lua".source = ./lua/lsp.lua;
  home.file.".config/nvim/lua/misc.lua".source = ./lua/misc.lua;
  home.file.".config/nvim/lua/remap.lua".source = ./lua/remap.lua;
}
