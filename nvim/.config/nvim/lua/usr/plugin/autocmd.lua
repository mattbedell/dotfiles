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

vim.api.nvim_create_autocmd("WinNew", {
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= "" then
      vim.api.nvim_win_call(0, function()
        vim.cmd("set winhighlight=NormalNC:Normal")
      end)
    end
  end,
})
