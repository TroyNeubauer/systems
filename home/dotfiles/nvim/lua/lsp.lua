
local lsp = require('lsp-zero').preset({})

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
}


lsp.set_preferences({
    suggest_lsp_servers = false,
})


lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", ",h", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", ",d", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", ",i", function() vim.lsp.buf.implementation() end, opts)
  vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help() end, opts)
  vim.keymap.set("n", "<space>d", function() vim.lsp.buf.type_definition() end, opts)
  vim.keymap.set("n", ",t", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", ",w", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", ",r", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format() end, opts)

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", ",n", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", ",d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>c", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.new_server({
  name = 'rust-analyzer',
  cmd = {'rust-analyzer'},
  filetypes = {'rust'},
  root_dir = function()
    local root = lsp.dir.find_first({'Cargo.lock'})
    print(root)
    return root
  end
})

lsp.setup()
