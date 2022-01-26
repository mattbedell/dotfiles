local vim = vim

-- local lsp_diagnostics = require'lsp-status.diagnostics'
-- local lsp_messages = require'lsp-status.messaging'.messages

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

-- local function status_inactive()
--   local stl_text = ' '
--   ..buf_path(false)
--   ..' ' .. '%h%w%q'
--   ..'%m'
--   ..'%='
--   ..'%-6.(%l:%c%)'
--   ..' %-4.(%P%)'

--   vim.wo.statusline = stl_text
-- end

local function diagnostics(level)
  if usr_util.length(vim.lsp.buf_get_clients()) == 0 then
    return ''
  end
  local count = usr_util.length(vim.diagnostic.get(0, { severity = level }))

  if count ~= 0 then
    return ' '..count..' '
  end

  return ' _ '
end

local function get_status(full_path, git_branch)

  -- @TODO: this is bad, refactor
  -- local diagnostic_display = diagnostics()

  local git_branch_str = ''
  if git_branch then
    git_branch_str = git()
  end

  local stl_text = ' '
  ..buf_path(full_path)
  ..' ' .. '%h%w%q'
  .. git_branch_str
  ..'%#stlWarn#%m%*%r'
  ..'%= '
  ..'%#stlLspError#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics(vim.diagnostic.severity.ERROR)")}]]
  ..'%#stlLspWarning#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics(vim.diagnostic.severity.WARN)")}]]
  ..'%#stlLspInformation#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics(vim.diagnostic.severity.INFO)")}]]
  ..'%#stlLspHint#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics(vim.diagnostic.severity.HINT)")}]]
  ..'%*'
  ..' %-6.(%l:%c%)'
  ..' %-4.(%P%)'

  vim.wo.statusline = stl_text
end

M.get_status = get_status
M.diagnostics = diagnostics

usr_util.create_augroups({
  UsrStatusLine = {
    {'WinLeave', '*', [[lua require'usr.plugin.statusline'.get_status(false, false)]]},
    {'WinEnter,BufEnter', '*', [[lua require'usr.plugin.statusline'.get_status(true, true)]]},
    {'User', 'LspDiagnosticsChanged', 'redrawstatus!'}
  }
})

return M
