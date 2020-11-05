-- reference for async operations:
-- https://github.com/neovim/nvim-lspconfig/blob/26e633f6113bd0783e2491596e5ef1507580bec1/lua/nvim_lsp/util.lua#L411-L472

local uv = vim.loop
local usr_util = require'usr.util'

local external_values = {}

local function ensure_buf(winnr, bufnr)
  if not external_values[winnr] then
    external_values[winnr] = {}
  end

  if not external_values[winnr][bufnr] then
    external_values[winnr][bufnr] = {}
  end
end

local function git_branch()
  local handle
  local bufnr

  local winnr = vim.api.nvim_get_current_win()

  ensure_buf(winnr, bufnr)

  if vim.api.nvim_win_is_valid(winnr) then
    bufnr = vim.api.nvim_win_get_buf(winnr)
  else
    external_values[winnr] = nil
    return nil
  end

  local branch = external_values[winnr][bufnr].git_branch

  local stdin = uv.new_pipe(false)
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)

  local function update_chunk(_, chunk)
    if chunk then
      branch = chunk
    end
  end

  local function on_exit(exitCode, signal)
    stdin:close()
    stdout:close()
    stderr:close()
    handle:close()

    if exitCode == 0 and signal == 0 then
      external_values[winnr][bufnr].git_branch = branch
      vim.schedule(function()
        vim.api.nvim_command('doautocmd User StatusLineUpdateActive')
      end)
    end
  end

  -- local update_chunk_wrapped = vim.schedule_wrap(update_chunk)
  -- local on_exit_wrapped = vim.schedule_wrap(on_exit)

  handle, _ = uv.spawn('git', {
    stdio = {stdin, stdout, stderr},
    args={'branch', '--show-current'},
  }, on_exit)

  stdout:read_start(update_chunk)
  stderr:read_start(function(_, chunk)
    if chunk then
      external_values[winnr][bufnr].git_branch = '~error~'
    end
  end)
end

local function get_external_value(winnr, bufnr, value, prefix, suffix)
  ensure_buf(winnr,bufnr)
  if external_values[winnr][bufnr][value] then
    return prefix .. external_values[winnr][bufnr][value] .. suffix
  end
  return ''
end

usr_util.create_augroups({
  UsrStatusLineExternal = {
    {'FocusGained', '*', [[lua require'usr.plugin.statusline.external'.git_branch()]]},
  }
})

local M = {}

M.get_external_value = get_external_value
M.git_branch = git_branch

return M
