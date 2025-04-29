local vim = vim

-- local lsp_diagnostics = require'lsp-status.diagnostics'
-- local lsp_messages = require'lsp-status.messaging'.messages

local usr_util = require'usr.util'
local lsp_last_status = ''

local M = {}

local function git()
  local stl_text = ''
  if vim.fn.exists('g:loaded_fugitive') == 1 and vim.bo.modifiable then
    local git_head = vim.fn['fugitive#Head']()
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
  if usr_util.length(vim.lsp.get_clients({ bufnr = 0 })) == 0 then
    return ''
  end
  local count = usr_util.length(vim.diagnostic.get(0, { severity = level }))

  if count ~= 0 then
    return ' '..count..' '
  end

  return ' _ '
end

local function lsp_set_last_status(status)
  local lsp_status = ''
  if status then
    lsp_status = status
  else
    lsp_status = vim.lsp.status()
  end
  lsp_last_status = lsp_status
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
  ..' ' .. [[%{luaeval("require'usr.plugin.statusline'.lsp_get_last_status()")}]]
  ..'%= '
  ..'%#stlLspError#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics(vim.diagnostic.severity.ERROR)")}]]
  ..'%#stlLspWarning#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics(vim.diagnostic.severity.WARN)")}]]
  ..'%#stlLspInformation#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics(vim.diagnostic.severity.INFO)")}]]
  ..'%#stlLspHint#%' .. [[{luaeval("require'usr.plugin.statusline'.diagnostics(vim.diagnostic.severity.HINT)")}]]
  ..'%*'
  ..' %-6.(%l:%c%)'
  ..' %-4.(%P%)'

  return stl_text
end

M.get_status = get_status
M.diagnostics = diagnostics
M.lsp_get_last_status = function()
  return lsp_last_status
end

local lsp_status_timer = vim.uv.new_timer()

local group = vim.api.nvim_create_augroup('lsp_statusline', { clear = true })
vim.api.nvim_create_autocmd({ 'LspProgress', 'DiagnosticChanged' }, {
  group = group,
  pattern = {'begin', 'report'},
  callback = function(args)
    lsp_status_timer:stop()
    lsp_set_last_status()
    vim.cmd('redrawstatus')
  end,
})
vim.api.nvim_create_autocmd({ 'LspProgress' }, {
  group = group,
  pattern = 'end',
  callback = function(args)
    lsp_status_timer:stop()
    lsp_status_timer:start(2000, 0, vim.schedule_wrap(function ()
      lsp_set_last_status('')
      vim.cmd('redrawstatus')
    end
    ))
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  group = group,
  pattern = '*',
  callback = function(args)
    vim.cmd('redrawstatus')
  end,
})
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  group = group,
  pattern = '*',
  callback = function(args)
    vim.wo.statusline = get_status(true, true)
  end,
})
vim.api.nvim_create_autocmd({ 'WinEnter' }, {
  group = group,
  pattern = '*',
  callback = function(args)
    vim.wo.statusline = get_status(true, true)
  end,
})
vim.api.nvim_create_autocmd({ 'WinLeave' }, {
  group = group,
  pattern = '*',
  callback = function(args)
    vim.wo.statusline = get_status(false, false)
  end,
})

return M
