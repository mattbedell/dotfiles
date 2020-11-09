local vim = vim

-- local lsp_diagnostics = require'lsp-status.diagnostics'
-- local lsp_messages = require'lsp-status.messaging'.messages

local usr_util = require'usr.util'

local M = {}
local severity_levels = {
  'Error',
  'Warning',
  'Info',
  'Hint',
}

local function get_all_diagnostics()
  local result = {}
  -- local bufnr = vim.api.nvim_get_current_buf()

  for _, level in ipairs(severity_levels) do
    result[level] = vim.lsp.diagnostic.get_count(0, level)
  end
  return result
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

-- local function diagnostics()
--   if #vim.lsp.buf_get_clients() == 0 then
--     return ''
--   end

--   local buf_diagnostics = get_all_diagnostics()

--   local diagnostic_display = {}

--   local hiGroup = '%#Pmenu#'
--   for _, level in ipairs(severity_levels) do
--     local count = buf_diagnostics[level]
--     if count > 0 then
--       local hiLevel = '%#stlLsp' .. level .. '#'
--       table.insert(diagnostic_display, hiLevel ..  buf_diagnostics[level])
--     end
--   end

--   if #diagnostic_display > 0 then
--     local spacer = hiGroup .. ' %*'
--     return '%4.10(' .. spacer .. usr_util.join(diagnostic_display, hiGroup .. ' %*') .. spacer .. '%)'
--   end

--   return ''
-- end

local function diagnostics(level)
  if #vim.lsp.buf_get_clients() == 0 then
    return ''
  end

  local count = vim.lsp.diagnostic.get_count(0, level)

  if count ~= 0 then
    return ' '..count..' '
  end

  return ''
end

local function status_active()

  -- @TODO: this is bad, refactor
  -- local diagnostic_display = diagnostics()

  local stl_text = ' '
  ..buf_path(true)
  ..' ' .. '%h%w%q'
  .. git()
  ..'%#stlWarn#%m%*%r'
  ..'%= '
  ..'%#stlLspError#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics('Error')")}]]
  ..'%#stlLspWarning#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics('Warning')")}]]
  ..'%#stlLspInfo#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics('Info')")}]]
  ..'%#stlLspHint#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics('Hint')")}]] .. '%*'
  ..' %6.(%l:%c%)'
  ..' %-4.(%P%)'

  vim.wo.statusline = stl_text
end

M.status_active = status_active
M.status_inactive = status_inactive
M.diagnostics = diagnostics

usr_util.create_augroups({
  UsrStatusLine = {
    {'WinLeave', '*', [[lua require'usr.plugin.statusline'.status_inactive()]]},
    {'WinEnter,BufEnter', '*', [[lua require'usr.plugin.statusline'.status_active()]]},
    {'User', 'LspDiagnosticsChanged', 'redrawstatus!'}
  }
})

return M
