
local lsp = require('lsp-zero').preset({})

local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    --['<C-b>'] = cmp.mapping.scroll_docs(-4),
    --['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    {
      name = 'spell',
      option = {
        keep_all_entries = false,
        enable_in_context = function()
          return true
        end,
      },
    }
  })
})

vim.opt.spell = true
vim.opt.spelllang = { 'en_us', 'de' }
-- Symlink `~/.config/nvim/spell/en.utf-8.add` to point at `home/programs/neovim/en.utf-8.add` in this repo so we can check it in

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

lsp.set_preferences({
  -- Must be configured explicitly through nix
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

  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  --vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  --vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", ",n", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", ",b", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>c", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.new_client({
  name = 'rust-analyzer',
  cmd = {'rust-analyzer'},
  filetypes = {'rust'},
  root_dir = function()
    local root = lsp.dir.find_first({'Cargo.lock'})
    print(root)
    return root
  end
})

lsp.new_client({
  name = 'clangd',
  cmd = {'clangd'},
  filetypes = {'c', 'cpp', 'cc'},
  root_dir = function()
    local root = lsp.dir.find_first({'Makefile'})
    return root
  end
})

lsp.setup()

