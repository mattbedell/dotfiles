vim.api.nvim_command([[command Sp set spell!]])

local theme = vim.api.nvim_create_augroup('ThemeCustom', { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = theme,
  pattern = "gruvbox",
  callback = function()
    if vim.g.gruvbox_contrast_dark and vim.opt.background.get() == 'dark' then
      vim.cmd('highlight Normal guibg=#000000 guifg=#fce8c3')
      vim.cmd('highlight SpecialKey guifg=#ff00ff ctermfg=201 cterm=bold')
      vim.cmd('highlight CursorLine ctermbg=233 guibg=#121212')
      vim.cmd('highlight CursorLineNR cterm=bold ctermbg=233 guibg=#121212')
      vim.cmd('highlight GruvboxRed guifg=#ef2f27')
      vim.cmd('highlight GruvboxOrange guifg=#ff5f00')
      vim.cmd('highlight GruvboxBlue guifg=#0aaeb3')
      vim.cmd('highlight GruvboxPurple guifg=#ff5c8f')
    else
      vim.cmd('highlight MatchParen guibg=#736a57 guifg=#a89984')
    end
    vim.cmd('highlight clear SignColumn')
    vim.cmd('highlight clear NormalFloat')
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = theme,
  pattern = '*',
  callback = function()
    local custBg = vim.fn.synIDattr(vim.fn.hlID('CursorLine'), 'bg#')
    vim.cmd('hi NormalNC guibg=' .. custBg)
    vim.cmd('hi VertSplit guibg=' .. custBg)
  end,
})
