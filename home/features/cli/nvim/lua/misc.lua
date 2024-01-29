-- Prevent rust-analyzer from hogging the lock file
vim.fn.setenv("CARGO_TARGET_DIR", "/tmp/nvim-rust-target"..os.getenv("PWD"))

require("telescope").load_extension("zf-native")

vim.o.termguicolors = true
vim.o.t_co = 256

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")

-- Permanent undo
vim.o.undodir = "/home/troy/.vimdid"
vim.o.undofile = true

-- Highlight on search
vim.o.hlsearch = true
-- Show line numbers
vim.wo.number = true
vim.o.mouse = 'a'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.cmdheight = 1
