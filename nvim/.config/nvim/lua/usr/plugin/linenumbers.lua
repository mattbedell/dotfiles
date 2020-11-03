local usr_util = require'usr.util'

-- " toggle hybrid line numbers based on mode
-- set number relativenumber
-- augroup numbertoggle
--   autocmd!
--   autocmd WinEnter,BufEnter,FocusGained,InsertLeave * if &l:buftype !=# 'help' | set relativenumber
--   autocmd WinLeave,BufLeave,FocusLost,InsertEnter   * set norelativenumber
--   autocmd WinEnter * set signcolumn=number
--   autocmd WinLeave * set signcolumn=no
-- augroup END

local relative_numbers = false

local function toggle_relative(isActive)
  if vim.bo.buftype ~= 'help' then
    if isActive == true then
      vim.wo.relativenumber = true
      vim.wo.number = true
    else
      vim.wo.relativenumber = false
    end
  else
    vim.wo.number = false
  end
end

local function set_relative_numbers()
  vim.wo.signcolumn = 'number'
  toggle_relative(true)
  usr_util.create_augroups({
    UsrLineNumbers = {
      {'WinEnter,BufEnter,FocusGained,InsertLeave', '*', [[lua require'usr.plugin.linenumbers'.toggle_relative(true)]]},
      {'WinLeave,BufLeave,FocusLost,InsertEnter', '*', [[lua require'usr.plugin.linenumbers'.toggle_relative(false)]]},
      {'WinEnter', '*', [[lua vim.wo.signcolumn='number']]},
      {'WinLeave', '*', [[lua vim.wo.signcolumn='no']]},
    }
  })
end

local function set_sign_column()
  vim.wo.number = false
  vim.wo.signcolumn = 'yes'
  local winnr = vim.fn.winnr()
  vim.api.nvim_command('windo set nonumber | set norelativenumber | set signcolumn=yes | exe '..winnr..'. "wincmd w"')
end

local function toggle_relative_numbers()
  if relative_numbers == true then
    relative_numbers = false
  else
    relative_numbers = true
  end

  if relative_numbers == true then
    set_relative_numbers()
  else
    usr_util.create_augroups({
      UsrLineNumbers = {}
    })
    set_sign_column()
  end
end

vim.api.nvim_command([[command RelativeNumberToggle lua require'usr.plugin.linenumbers'.toggle_relative_numbers()]])

local M = {}

M.toggle_relative = toggle_relative
M.toggle_relative_numbers = toggle_relative_numbers

return M
