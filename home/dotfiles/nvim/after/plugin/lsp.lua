local lsp = require("lsp-zero")
vim.o.completeopt = "menuone,noselect,preview"

lsp.preset("recommended")

lsp.ensure_installed({
  'clangd',
  'rust_analyzer',
  'rnix',
  'asm_lsp',
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})

lsp.configure('lua-language-server', {
  settings = {
    ['asm'] = {
      filetypes = { "asm", "s", "S" }
    }
  }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
    [''] = cmp.config.disable,
  ['<C-K>'] = cmp.mapping.scroll_docs(-3),
  ['<C-J>'] = cmp.mapping.scroll_docs(3),
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp.setup {
    preselect = cmp.PreselectMode.None,
    formatting = {
        format = function(_, vim_item)
            vim_item.menu = ""
            vim_item.kind = ""
            return vim_item
        end
    },
 -- window = {
 --      completion =  cmp.config.window.bordered(),
 --          border = 'rounded',
--          winhighlight = "Normal:MyNormal,FloatBorder:MyFloatBorder,CursorLine:MyCursorLine",
     -- maxwidth = math.floor((MAX_KIND_WIDTH * 2) * (vim.o.columns / (MAX_KIND_WIDTH * 2 * 16 / 9))),
     -- maxheight = math.floor(MAX_KIND_WIDTH * (MAX_KIND_WIDTH / vim.o.lines)),


     -- documentation = cmp.config.window.bordered(),
--      winhighlight = "Normal:DocumentationNormal,FloatBorder:MyFloatBorder",
     -- maxwidth = math.floor((MAX_KIND_WIDTH * 2) * (vim.o.columns / (MAX_KIND_WIDTH * 2 * 16 / 9))),
     -- maxheight = math.floor(MAX_KIND_WIDTH * (MAX_KIND_WIDTH / vim.o.lines)),
  -- },
}


-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = true,
})

vim.keymap.set("n", "<space>e", function() vim.diagnostic.open_float() end)
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end)
vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end)

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

   --bind('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', noremap)
  --   --buf_set_keymap('n', ',D', '<Cmd>lua vim.lsp.buf.declaration()', opts)
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
end)

lsp.setup()


vim.diagnostic.config({
    manage_nvim_cmp = true,
    -- virtual_text = true
})
