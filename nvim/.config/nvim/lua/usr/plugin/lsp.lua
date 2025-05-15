local nvim_lsp = require'lspconfig'

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local float_border = "double"

vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  severity_sort = true,
  float = {
    severity_sort = true,
    source = 'always',
    border = float_border,
  },
})

local on_attach_lsp = function(client, bufnr)
  if client.name == 'yamlls' then
    client.server_capabilities.documentFormattingProvider = true
  end

  if not bufnr or bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  vim.cmd(string.format('augroup LspAttach:%s:%s', bufnr, client.id))
  vim.cmd('au!')
  vim.cmd(
    string.format('autocmd InsertEnter <buffer=%s> :lua vim.diagnostic.hide(nil, %s)', bufnr, bufnr)
  )
  vim.cmd(
    string.format('autocmd InsertLeave <buffer=%s> :lua vim.diagnostic.show(nil, %s)', bufnr, bufnr)
  )
  vim.cmd('augroup END')

  vim.keymap.set('n', 'K', function()
    vim.lsp.buf.hover({ border = float_border })
  end, { buffer = true, silent = true, noremap = true })

  vim.keymap.set('n', '<leader>lh', function()
    vim.lsp.buf.signature_help({ border = float_border })
  end, { buffer = true, silent = true, noremap = true })

  vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<c-w><c-]>', '<c-w>v<c-]>', {noremap = false, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>le', '<cmd>lua vim.diagnostic.open_float()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>', {noremap = true, silent = true})
  vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, {silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true})

  vim.api.nvim_win_set_option(0, "foldmethod", "expr")
  vim.api.nvim_win_set_option(0, "foldexpr", "nvim_treesitter#foldexpr()")
end

nvim_lsp.ts_ls.setup{
  root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
  on_attach = on_attach_lsp,
  capabilities = capabilities,
  init_options = {
    preferences = {
      includeCompletionsForModuleExports = false
    }
  }
}

-- microsoft pyls requires dotnet and is annoying to build and install, to use the evil palantir LS
-- nvim_lsp.pyls_ms.setup{
--   on_attach = on_attach_lsp,
--   capabilities = capabilities,
-- }

-- community fork of palantir/pyls
nvim_lsp.pylsp.setup{
  on_attach = on_attach_lsp,
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
  on_attach = on_attach_lsp,
  capabilities = capabilities,
}

nvim_lsp.yamlls.setup{
  on_attach = on_attach_lsp,
  capabilities = capabilities,
  settings = {
    yaml = {
      keyOrdering = false,
      format = {
        enable = true,
      },
    },
  },
}

nvim_lsp.graphql.setup{
  on_attach = on_attach_lsp,
  capabilities = capabilities,
}

nvim_lsp.terraformls.setup{
  on_attach = on_attach_lsp,
  capabilities = capabilities,
  filetypes = { "terraform", "terraform-vars", "hcl" }
}

nvim_lsp.protols.setup{
  capabilities = capabilities
}

-- nvim_lsp.sumneko_lua.setup{
--   root_dir = nvim_lsp.util.root_pattern(".git"),
--   on_attach = on_attach_lsp,
--   capabilities = capabilities,
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = {"vim", "map", "filter", "range", "reduce", "head", "tail", "nth"},
--         disable = {"redefined-local"},
--       },
--       runtime = {version = "LuaJIT"},
--     }
--   }
-- }

nvim_lsp.eslint.setup{
  on_attach = on_attach_lsp,
  -- capabilities = capabilities,
  settings = {
    format = {
      enable = true,
    },
  },
}

local efm_javascript = {
  -- lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
  -- lintStdin = true,
  -- lintFormats = {
  --   "%f(%l,%c): %tarning %m",
  --   "%f(%l,%c): %rror %m",
  -- },
  -- lintIgnoreExitCode = true,
  formatCommand = "prettier --stdin-filepath ${INPUT}",
  formatStdin = true,
  lintSource = "eslint",
}

nvim_lsp.efm.setup{
  on_attach = on_attach_lsp,
  init_options = {documentFormatting = true},
  filetypes = {'javascript', 'javascriptreact', 'typescript', 'python'},
  settings = {
    rootMarkers = {".git/"},
    languages = {
      javascript = {efm_javascript},
      typescript = {efm_javascript},
      javascriptreact = {efm_javascript},
      python = {{
        formatCommand = "black --fast -",
        formatStdin = true,
      }},
    },
  },
}

nvim_lsp.cssls.setup{
  root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
  on_attach = on_attach_lsp,
  capabilities = capabilities,
}

nvim_lsp.html.setup{
  root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
  on_attach = on_attach_lsp,
  capabilities = capabilities,
}

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ">>",
      [vim.diagnostic.severity.WARN]  = "!>",
      [vim.diagnostic.severity.HINT]  = "?>",
      [vim.diagnostic.severity.INFO]  = "<>",
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
      [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
      [vim.diagnostic.severity.INFO]  = "DiagnosticSignInformation",
    }
  }
})
