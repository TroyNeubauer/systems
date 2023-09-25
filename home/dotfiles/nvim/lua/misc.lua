-- Prevent rust-analyzer from hogging the lock file
vim.fn.setenv("CARGO_TARGET_DIR", "/tmp/nvim-rust-target"..os.getenv("PWD"))

vim.o.termguicolors = true
vim.o.t_co = 256

vim.cmd('colorscheme base16-gruvbox-dark-hard')

-- Permanent undo
vim.o.undodir = "~/.vimdid"
vim.o.undofile = true

-- Highlight on search
vim.o.hlsearch = false
-- Show line numbers
vim.wo.number = true
vim.o.mouse = 'a'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.cmdheight = 1
