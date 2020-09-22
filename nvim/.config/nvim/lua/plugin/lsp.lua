nvim_lsp = require'nvim_lsp'
on_attach_lsp = function(client)
  require'completion'.on_attach(client)
  require'diagnostic'.on_attach(client)
  vim.fn.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', ']e', '<cmd>NextDiagnosticCycle<CR>', {noremap = true, silent = true})
  vim.fn.nvim_buf_set_keymap(0, 'n', '[e', '<cmd>PrevDiagnosticCycle<CR>', {noremap = true, silent = true})
end

nvim_lsp.tsserver.setup{
  root_dir = nvim_lsp.util.root_pattern(".git", "package.json"),
  on_attach = on_attach_lsp
}

nvim_lsp.pyls_ms.setup{
  on_attach = on_attach_lsp
}
nvim_lsp.rust_analyzer.setup{
  on_attach = on_attach_lsp
}

vim.fn.sign_define("LspDiagnosticsErrorSign", {
  text = ">>",
  texthl = "LspDiagnosticsError",
})
vim.fn.sign_define("LspDiagnosticsWarningSign", {
  text = "!>",
  texthl = "LspDiagnosticsWarning",
})
vim.fn.sign_define("LspDiagnosticsInformationSign", {
  text = "^>",
  texthl = "LspDiagnosticsInformation",
})
vim.fn.sign_define("LspDiagnosticsHintSign", {
  text = "^^",
  texthl = "LspDiagnosticsHint",
})
