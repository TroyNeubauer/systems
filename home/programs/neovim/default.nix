{ config, pkgs, ...}:

{
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
  # Use the Nix package search engine to find
  # even more plugins : https://search.nixos.org/packages
}
