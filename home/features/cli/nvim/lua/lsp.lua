
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
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

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.lock' },
})

-- Pull in nix-generated lsp selection (rust-glancer or rust-analyzer)
local ok, rust_lsp = pcall(require, 'rust_lsp')
if not ok then rust_lsp = 'rust-glancer' end

vim.lsp.config('rust_glancer', {
  cmd = { 'rust-glancer', 'lsp' },
  cmd_env = { RUST_GLANCER_LOG = 'warn' },
  filetypes = { 'rust' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    -- Attach stdlib and dep cache from default location so rust-glance doesnt spawn a new instance
    local cargo_home = vim.env.CARGO_HOME or (vim.env.HOME .. '/.cargo')
    local is_library = vim.startswith(fname, cargo_home .. '/registry/src/')
      or vim.startswith(fname, cargo_home .. '/git/checkouts/')
      or fname:find('/lib/rustlib/src/rust/library/', 1, true) ~= nil
    if is_library then
      local client = vim.lsp.get_clients({ name = 'rust_glancer' })[1]
      if client then on_dir(client.config.root_dir) end
      return
    end
    -- glancer can't run without a workspace folder, so skip if missing
    local root = vim.fs.root(fname, { 'Cargo.lock' })
    if root then on_dir(root) end
  end,
})

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp' },
  root_markers = { 'build' },
})

vim.lsp.enable({
  rust_lsp == 'rust-glancer' and 'rust_glancer' or 'rust_analyzer',
  'clangd',
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf, remap = false }

    vim.keymap.set("n", ",h", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", ",d", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", ",i", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<space>d", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", ",t", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", ",w", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", ",r", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format() end, opts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", ",n", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
    vim.keymap.set("n", ",b", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
  end,
})

for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
    local default_diagnostic_handler = vim.lsp.handlers[method]
    vim.lsp.handlers[method] = function(err, result, context, config)
        if err ~= nil and err.code == -32802 then
            return
        end
        return default_diagnostic_handler(err, result, context, config)
    end
end
