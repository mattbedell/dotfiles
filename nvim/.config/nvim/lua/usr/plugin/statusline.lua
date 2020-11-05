local vim = vim
local usr_util = require'usr.util'
local sl = require'usr.plugin.statusline.external'

local M = {}

local function update_highlights()
  usr_util.extend_hi_gui('StatusLine', 'stlWarn', {
    reverse = true,
    bold = true,
    bg = usr_util.get_hi_attr('Question', 'fg', 'gui'),
    fg = usr_util.get_hi_attr('PmenuThumb', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('StatusLineNC', 'stlWarnNC', {
    reverse = true,
    bold = true,
  })

  usr_util.extend_hi_gui('StatusLine', 'stlGit', {
    reverse = true,
    bg = usr_util.get_hi_attr('Identifier', 'fg', 'gui'),
    fg = usr_util.get_hi_attr('PmenuThumb', 'bg', 'gui'),
  })


  local statusline_fg = usr_util.get_hi_attr('PmenuThumb', 'bg#', 'gui')
  vim.api.nvim_command('highlight StatusLine cterm=reverse gui=reverse guifg=' ..statusline_fg)
end

usr_util.create_augroups({
  UpdateStatusLineHighlights = {
  }
})

-- local function git()
--   local stl_text = ''
--   if vim.fn.exists('g:loaded_fugitive') and vim.bo.modifiable then
--     local git_head = vim.fn['fugitive#head']()
--     stl_text = string.len(git_head) > 0 and '%#stlGit#[' .. git_head .. ']%*' or ''
--   end
--   return stl_text
-- end

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
  local winnr = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  local stl_text = ' '
  ..buf_path(true)
  ..' ' .. '%h%w%q'
  .. sl.get_external_value(winnr, bufnr, 'git_branch', '[', ']')
  ..'%#stlWarn#%m%*%r'
  ..'%='
  ..'%-10.(%l:%c%)'
  ..'%-4.(%P%)'

  vim.wo.statusline = stl_text
end

local function update_status(isActive)
  if isActive == true then
    return status_active()
  else
    return status_inactive()
  end
end

update_highlights()

M.update_highlights = update_highlights
M.update_status = update_status

usr_util.create_augroups({
  UsrStatusLine = {
    {'WinLeave', '*', [[lua require'usr.plugin.statusline'.update_status(false)]]},
    {'WinEnter,BufEnter', '*', [[lua require'usr.plugin.statusline'.update_status(false)]]},
    {'User', 'StatusLineUpdateActive', [[lua require'usr.plugin.statusline'.update_status(true)]]},
    {'ColorScheme', '*', [[lua require'usr.plugin.statusline'.update_highlights()]]},
    {'OptionSet', 'background', [[lua require'usr.plugin.statusline'.update_highlights()]]},
  }
})

return M
