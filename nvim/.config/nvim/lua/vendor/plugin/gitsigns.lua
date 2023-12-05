require('gitsigns').setup()
vim.api.nvim_command('highlight link GitSignsAdd DiagnosticHint')
vim.api.nvim_command('highlight link GitSignsChange DiagnosticInfo')
vim.api.nvim_command('highlight link GitSignsDelete DiagnosticError')
