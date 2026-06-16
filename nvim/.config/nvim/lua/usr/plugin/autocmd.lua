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

local AutoIndentUtil = vim.api.nvim_create_augroup('auto-indent-util', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = AutoIndentUtil,
  pattern = { '*.ts' },
  callback = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false)
    local space_count = 0
    for _, line in ipairs(lines) do
      if space_count > 10 then
        vim.bo.expandtab = true
        break
      end

      if line:find("^\t") then
        vim.bo.expandtab = false
        break
      end

      if line:find("^ ") then
        space_count = space_count + 1
      end
    end
  end
})
