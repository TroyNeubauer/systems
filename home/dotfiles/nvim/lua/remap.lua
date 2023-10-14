local opts =  { noremap = true, silent = true }
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '

vim.opt.listchars = { space = '_', eol = '¶', extends = '»', precedes = '«', trail = '•', space = '.' }

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

-- Toggle spell check on and off
function toggle_whitespace_list()
  if vim.opt.list then
    vim.opt.list = false
    vim.notify('off')
  else 
    vim.opt.list = true 
    vim.notify('on')
  end
end

vim.keymap.set("", "<leader>,", "<cmd>lua toggle_whitespace_list()<CR>", opts)

-- telescope
local telescope = require('telescope')
vim.keymap.set("n", "<leader>o", "<cmd>lua require('telescope.builtin').find_files()<CR>", {})
vim.keymap.set("n", "<leader>h", "<cmd>lua require('telescope.builtin').buffers()<CR>", {})
vim.keymap.set("n", "<leader>s", "<cmd>lua require('telescope.builtin').live_grep()<CR>", {})

