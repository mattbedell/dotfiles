local vim = vim

local lsp_diagnostics = require'lsp-status.diagnostics'
local lsp_messages = require'lsp-status.messaging'.messages

local usr_util = require'usr.util'
local diagnostic_sign = require'usr.lsp'.diagnostic_sign

local M = {}

local function diagnostics()
  local all_diagnostics = {}

  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end


  local buf_diagnostics = lsp_diagnostics()

  if buf_diagnostics.errors and buf_diagnostics.errors > 0 then
    all_diagnostics.error = buf_diagnostics.errors
  end

  if buf_diagnostics.warnings and buf_diagnostics.warnings > 0 then
    all_diagnostics.warning = buf_diagnostics.warnings
  end

  if buf_diagnostics.info and buf_diagnostics.info > 0 then
    all_diagnostics.info = buf_diagnostics.info
  end

  if buf_diagnostics.hints and buf_diagnostics.hints > 0 then
    all_diagnostics.hint = buf_diagnostics.hint
  end

  local diagnostic_display = {}

  local hiGroup = '%#Pmenu#'
  for level, value in pairs(all_diagnostics) do
    local hiLevel = '%#stlLsp' .. (level:gsub("^%l", string.upper)) .. '#'
    -- diagnostic_display = diagnostic_display .. hiLevel .. ' ' .. value
    table.insert(diagnostic_display, hiLevel ..  value )
  end

  if #diagnostic_display then
    local spacer = hiGroup .. ' %*'
    return '%4.10(' .. spacer .. usr_util.join(diagnostic_display, hiGroup .. ' %*') .. spacer .. '%)'
  end

  return ''
end

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
  ..'%-6.(%l:%c%)'
  ..' %-4.(%P%)'

  vim.wo.statusline = stl_text
end

local function status_active()

  -- @TODO: this is bad, refactor
  local diagnostic_display = diagnostics()

  local stl_text = ' '
  ..buf_path(true)
  ..' ' .. '%h%w%q'
  .. git()
  ..'%#stlWarn#%m%*%r'
  ..'%='
  ..diagnostic_display
  ..'%6.(%l:%c%)'
  ..' %-4.(%P%)'

  vim.wo.statusline = stl_text
end

M.status_active = status_active
M.status_inactive = status_inactive

usr_util.create_augroups({
  UsrStatusLine = {
    {'WinLeave', '*', [[lua require'usr.plugin.statusline'.status_inactive()]]},
    {'WinEnter,BufEnter', '*', [[lua require'usr.plugin.statusline'.status_active()]]},
    {'User', 'LspDiagnosticsChanged', [[lua require'usr.plugin.statusline'.status_active()]]}
  }
})

return M
