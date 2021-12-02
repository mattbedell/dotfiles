local nvim_lsp = require'lspconfig'

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.diagnostic.config({
  underline = false,
  virtual_text = false,
  severity_sort = true,
  float = {
    severity_sort = true,
    source = 'always',
  },
})

local on_attach_lsp = function(client, bufnr)
  -- require'lsp_signature'.on_attach({
  --   hint_enable = false,
  --   doc_lines = 0,
  --   handler_opts = {border = 'double'},
  -- })

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

  vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<c-w><c-]>', '<c-w>v<c-]>', {noremap = false, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>le', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', ']e', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '[e', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lc', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>', {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(0, 'n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>', {noremap = true})

  vim.api.nvim_win_set_option(0, "foldmethod", "expr")
  vim.api.nvim_win_set_option(0, "foldexpr", "nvim_treesitter#foldexpr()")
end

nvim_lsp.tsserver.setup{
  root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
  on_attach = on_attach_lsp,
  capabilities = capabilities,
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
}

nvim_lsp.graphql.setup{
  on_attach = on_attach_lsp,
  capabilities = capabilities,
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

local efm_javascript = {
  lintCommand = "eslint -f visualstudio --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {
    "%f(%l,%c): %tarning %m",
    "%f(%l,%c): %rror %m",
  },
  lintIgnoreExitCode = true,
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

vim.fn.sign_define("DiagnosticSignError", {
  text = '>>',
  texthl = "DiagnosticError",
})
vim.fn.sign_define("DiagnosticSignWarning", {
  text = '!>',
  texthl = "DiagnosticWarning",
})
vim.fn.sign_define("DiagnosticSignInformation", {
  text = '<>',
  texthl = "DiagnosticInformation",
})
vim.fn.sign_define("DiagnosticSignHint", {
  text = '?>',
  texthl = "DiagnosticHint",
})
