require('gruvbox').setup{
  italic = false,
  contrast = 'hard',
}

vim.cmd('colorscheme gruvbox')
vim.cmd('highlight clear SignColumn')
-- force StatusLine and StatusLineNC to be different so spaces aren't replaced with carats in the active statusline
vim.cmd('highlight StatusLine ctermfg=223')
