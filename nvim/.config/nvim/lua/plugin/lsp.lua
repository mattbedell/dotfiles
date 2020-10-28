nvim_lsp = require'nvim_lsp'
on_attach_lsp = function(client)
  require'completion'.on_attach(client)
  require'usr.diagnostic'.on_attach(client)
  require'usr.lsp'.on_attach(client)

  vim.fn.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<c-w><c-]>', '<c-w>v<c-]>', {noremap = false, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>lw', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>le', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', {noremap = true, silent = true})
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
}

-- nvim_lsp.diagnosticls.setup{
--   on_attach = on_attach_lsp,
--   filetypes={'javascript'},
--   init_options = {
--     linters = {
--       eslint = {
--         command = './node_modules/.bin/eslint',
--         rootPatterns = {'.git'},
--         debounce = 100,
--         args = {
--           '--stdin',
--           '--stdin-filename',
--           '%filepath',
--           '--format',
--           'json',
--         },
--         sourceName = 'eslint',
--         parseJson = {
--           errorsRoot = '[0].messages',
--           line = 'line',
--           column = 'column',
--           endLine = 'endLine',
--           endColumn = 'endColumn',
--           message = 'eslint: ${message} [${ruleId}]',
--           security = 'severity',
--         },
--         securities = {
--           [2] = 'error',
--           [1] = 'warning',
--         },
--       },
--     },
--     filetypes = {
--       javascript = 'eslint'
--     },
--     formatters = {
--       prettier = {
--         command = "./node_modules/.bin/prettier",
--         args = {"--stdin-filepath" ,"%filepath", '--single-quote', '--print-width 120'},
--       },
--     },
--     formatFiletypes = {
--       javascript = "prettier",
--     },
--   },
-- }

vim.fn.sign_define("LspDiagnosticsErrorSign", {
  text = ">>",
  texthl = "LspDiagnosticsError",
})
vim.fn.sign_define("LspDiagnosticsWarningSign", {
  text = "!>",
  texthl = "LspDiagnosticsWarning",
})
vim.fn.sign_define("LspDiagnosticsInformationSign", {
  text = "<>",
  texthl = "LspDiagnosticsInformation",
})
vim.fn.sign_define("LspDiagnosticsHintSign", {
  text = "<>",
  texthl = "LspDiagnosticsHint",
})
