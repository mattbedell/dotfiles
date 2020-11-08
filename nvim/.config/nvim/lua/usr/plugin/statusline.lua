local vim = vim
local usr_util = require'usr.util'

local M = {}




local function git()
  local stl_text = ''
  if vim.fn.exists('g:loaded_fugitive') and vim.bo.modifiable then
    local git_head = vim.fn['fugitive#head']()
    stl_text = string.len(git_head) > 0 and '%#stlGit#[' .. git_head .. ']%*' or ''
  end
  return stl_text
end

local function buf_path(is_active)
  local path = vim.fn.expand('%:~:.')
  if is_active then
    path = vim.fn.pathshorten(path)
  end
  return path
end

local function status_inactive()
  local stl_text = ' '
  ..buf_path(false)
  ..' ' .. '%h%w%q'
  ..'%m'
  ..'%='
  ..'%-10.(%l:%c%)'
  ..'%-4.(%P%)'

  vim.wo.statusline = stl_text
end

local function status_active()
  local stl_text = ' '
  ..buf_path(true)
  ..' ' .. '%h%w%q'
  .. git()
  ..'%#stlWarn#%m%*%r'
  ..'%='
  ..'%-10.(%l:%c%)'
  ..'%-4.(%P%)'

  vim.wo.statusline = stl_text
end

M.status_active = status_active
M.status_inactive = status_inactive

usr_util.create_augroups({
  UsrStatusLine = {
    {'WinLeave', '*', [[lua require'usr.plugin.statusline'.status_inactive()]]},
    {'WinEnter,BufEnter', '*', [[lua require'usr.plugin.statusline'.status_active()]]},
  }
})

return M
