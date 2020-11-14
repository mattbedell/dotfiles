local nvim_lsp = require'nvim_lsp'

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  virtual_text = false,
})

local on_attach_lsp = function(client, bufnr)
  require'completion'.on_attach(client)

  if not bufnr or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  vim.cmd(string.format('augroup LspAttach:%s:%s', bufnr, client.id))
  vim.cmd('au!')
  vim.cmd(
    string.format('autocmd BufLeave,InsertEnter <buffer=%s> :lua vim.lsp.diagnostic.clear(%s)', bufnr, bufnr)
  )
  vim.cmd(
    string.format('autocmd BufEnter,InsertLeave <buffer=%s> :lua vim.lsp.diagnostic.display(nil, %s, %s, { virtual_text = false })', bufnr, bufnr, client.id)
  )
  vim.cmd('augroup END')

  vim.fn.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<c-w><c-]>', '<c-w>v<c-]>', {noremap = false, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>lc', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})

  vim.api.nvim_win_set_option(0, "foldmethod", "expr")
  vim.api.nvim_win_set_option(0, "foldexpr", "nvim_treesitter#foldexpr()")
end

nvim_lsp.tsserver.setup{
  root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
  on_attach = on_attach_lsp,
}

nvim_lsp.pyls_ms.setup{
  on_attach = on_attach_lsp,
}
nvim_lsp.rust_analyzer.setup{
  on_attach = on_attach_lsp,
}

nvim_lsp.jsonls.setup{
  on_attach = on_attach_lsp,
}

nvim_lsp.sumneko_lua.setup{
  root_dir = nvim_lsp.util.root_pattern(".git"),
  on_attach = on_attach_lsp,
  settings = {
    Lua = {
      diagnostics = {
        globals = {"vim", "map", "filter", "range", "reduce", "head", "tail", "nth"},
        disable = {"redefined-local"},
      },
      runtime = {version = "LuaJIT"},
    }
  }
}

nvim_lsp.diagnosticls.setup{
  on_attach = on_attach_lsp,
  filetypes={'javascript', 'jsx', 'ts', 'tsx'},
  init_options = {
    linters = {
      eslint = {
        command = './node_modules/.bin/eslint',
        rootPatterns = {'.git'},
        debounce = 100,
        args = {
          '--stdin',
          '--stdin-filename',
          '%filepath',
          '--format',
          'json',
        },
        sourceName = 'eslint',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = 'eslint: ${message} [${ruleId}]',
          security = 'severity',
        },
        securities = {
          [2] = 'error',
          [1] = 'warning',
        },
      },
    },
    filetypes = {
      javascript = 'eslint'
    },
    formatters = {
      prettier = {
        command = "./node_modules/.bin/prettier",
        args = {"--stdin-filepath" ,"%filepath", '--single-quote', '--print-width 120'},
      },
    },
    formatFiletypes = {
      javascript = "prettier",
    },
  },
}

vim.fn.sign_define("LspDiagnosticsSignError", {
  text = '>>',
  texthl = "LspDiagnosticsError",
})
vim.fn.sign_define("LspDiagnosticsSignWarning", {
  text = '!>',
  texthl = "LspDiagnosticsWarning",
})
vim.fn.sign_define("LspDiagnosticsSignInformation", {
  text = '<>',
  texthl = "LspDiagnosticsInformation",
})
vim.fn.sign_define("LspDiagnosticsSignHint", {
  text = '?>',
  texthl = "LspDiagnosticsHint",
})
