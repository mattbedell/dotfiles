local vim = vim

-- local lsp_diagnostics = require'lsp-status.diagnostics'
-- local lsp_messages = require'lsp-status.messaging'.messages

local usr_util = require'usr.util'

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
  if usr_util.length(vim.lsp.buf_get_clients()) == 0 then
    return ''
  end
  local count = usr_util.length(vim.diagnostic.get(0, { severity = level }))

  if count ~= 0 then
    return ' '..count..' '
  end

  return ' _ '
end

-- https://github.com/teto/home/blob/master/config/nvim/lua/statusline.lua#L28
local function get_progress()
  if usr_util.length(vim.lsp.buf_get_clients()) == 0 then
    return ''
  end

  local msgs = {}
  local buf_messages = vim.lsp.util.get_progress_messages()
  for _, msg in ipairs(buf_messages) do
    local client_name = '[' .. msg.name .. ']'
    local contents = ''
    if msg.progress then
      contents = msg.title
      if msg.message then
        contents = contents .. ' ' .. msg.message
      end

      if msg.percentage then
        contents = contents .. ' [' .. msg.percentage .. '%]'
      end

    elseif msg.status then
      contents = msg.content
      if msg.uri then
        local filename = vim.uri_to_fname(msg.uri)
        filename = vim.fn.fnamemodify(filename, ':~:.')
        local space = math.min(40, math.floor(0.4 * vim.fn.winwidth(0)))
        if #filename > space then
          filename = vim.fn.pathshorten(filename)
        end

        contents = contents .. ' ' .. filename
      end
    else
      contents = msg.content
    end

    table.insert(msgs, client_name .. ' ' .. contents)
  end

  return table.concat(msgs, ' ')
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
  ..' ' .. [[%{luaeval("require'usr.plugin.statusline'.get_progress()")}]]
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
M.get_progress = get_progress
M.diagnostics = diagnostics

usr_util.create_augroups({
  UsrStatusLine = {
    {'WinLeave', '*', [[lua require'usr.plugin.statusline'.get_status(false, false)]]},
    {'WinEnter,BufEnter', '*', [[lua require'usr.plugin.statusline'.get_status(true, true)]]},
    {'User', 'LspDiagnosticsChanged', 'redrawstatus!'},
    {'User', 'LspProgressUpdate', 'redrawstatus!'}
  }
})

return M
