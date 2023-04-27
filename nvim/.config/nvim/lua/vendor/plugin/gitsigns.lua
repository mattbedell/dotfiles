require('gitsigns').setup()
vim.api.nvim_command('highlight link GitSignsAdd diffAdded')
vim.api.nvim_command('highlight link GitSignsChange diffChanged')
vim.api.nvim_command('highlight link GitSignsDelete diffRemoved')
