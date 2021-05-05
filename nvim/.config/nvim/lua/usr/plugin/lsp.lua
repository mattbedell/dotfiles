local nvim_lsp = require'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = false,
  virtual_text = false,
})

local on_attach_lsp = function(client, bufnr)

  if not bufnr or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  vim.cmd(string.format('augroup LspAttach:%s:%s', bufnr, client.id))
  vim.cmd('au!')
  vim.cmd(
    string.format('autocmd BufLeave,InsertEnter <buffer=%s> :lua vim.lsp.diagnostic.clear(%s)', bufnr, bufnr)
  )
  vim.cmd(
    string.format('autocmd BufEnter,InsertLeave <buffer=%s> :lua vim.lsp.diagnostic.display(nil, %s, %s, { virtual_text = false, underline = false })', bufnr, bufnr, client.id)
  )
  vim.cmd('augroup END')

  vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<c-w><c-]>', '<c-w>v<c-]>', {noremap = false, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lc', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', {noremap = true, silent = true})

  vim.api.nvim_win_set_option(0, "foldmethod", "expr")
  vim.api.nvim_win_set_option(0, "foldexpr", "nvim_treesitter#foldexpr()")
end

nvim_lsp.tsserver.setup{
  root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
  on_attach = function (client)
    client.resolved_capabilities.document_formatting = false
    on_attach_lsp(client)
  end,
  capabilities = capabilities,
}

-- microsoft pyls requires dotnet and is annoying to build and install, to use the evil palantir LS
-- nvim_lsp.pyls_ms.setup{
--   on_attach = on_attach_lsp,
--   capabilities = capabilities,
-- }

nvim_lsp.pyls.setup{
  on_attach = function (client)
    client.resolved_capabilities.document_formatting = false
    on_attach_lsp(client)
  end,
  capabilities = capabilities,
}

nvim_lsp.rust_analyzer.setup{
  on_attach = on_attach_lsp,
  capabilities = capabilities,
}

nvim_lsp.gopls.setup{
  on_attach = on_attach_lsp,
  capabilities = capabilities,
}

nvim_lsp.jsonls.setup{
  on_attach = function (client)
    client.resolved_capabilities.document_formatting = false
    on_attach_lsp(client)
  end,
  capabilities = capabilities,
}

nvim_lsp.yamlls.setup{
  on_attach = on_attach_lsp,
  capabilities = capabilities,
}

nvim_lsp.graphql.setup{
  on_attach = on_attach_lsp,
  capabilities = capabilities,
}

nvim_lsp.sumneko_lua.setup{
  root_dir = nvim_lsp.util.root_pattern(".git"),
  on_attach = on_attach_lsp,
  capabilities = capabilities,
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


nvim_lsp.cssls.setup{
  root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
  on_attach = function (client)
    client.resolved_capabilities.document_formatting = false
    on_attach_lsp(client)
  end,
  capabilities = capabilities,
}

nvim_lsp.html.setup{
  root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
  on_attach = function (client)
    client.resolved_capabilities.document_formatting = false
    on_attach_lsp(client)
  end,
  capabilities = capabilities,
}

local prettier =  {
  formatCommand = "prettier --stdin-filepath = ${INPUT}",
  formatStdin = true,
}

local eslint = {
  formatCommand = "eslint -f visualstudio --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintSource = "eslint",
}

nvim_lsp.efm.setup{
  -- on_attach = on_attach,
  init_options = {documentFormatting = true},
  settings = {
    log_file = "/Users/mbedell/efm.log",
    log_level = 1,
    rootMarkers = {".git/"},
    languages = {
      typescript = {prettier, eslint},
      javascript = {prettier, eslint},
      typescriptreact = {prettier, eslint},
      javascriptreact = {prettier, eslint},
      yaml = {prettier},
      json = {prettier},
      html = {prettier},
      scss = {prettier},
      css = {prettier},
      python = {
        black = {
          formatCommand = [[
            black --fast -
          ]],
          formatStdin = true,
        }
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "yaml",
    "json",
    "html",
    "scss",
    "css",
    "python",
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
