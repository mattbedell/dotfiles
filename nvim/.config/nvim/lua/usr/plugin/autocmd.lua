local usr_util = require'usr.util'

usr_util.create_augroups({
  WinAutoResize = {
    {'VimResized', '*', 'wincmd ='},
  }
})

local HLSearchGroup = vim.api.nvim_create_augroup('auto-hlsearch', { clear = true })

vim.api.nvim_create_autocmd('CursorMoved', {
  group = HLSearchGroup,
  callback = function ()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function () vim.cmd.nohlsearch() end)
    end
  end
})
