local usr_util = require'usr.util'

local notes_glob = vim.fn.expand('$NOTES_DIR') .. '/*.md'

local function new_note()
  local filename = vim.fn.strftime('%Y%m%d%H%M') .. '.md'
  local filepath = vim.fn.expand('$NOTES_DIR') .. '/' .. filename
  print(filepath)
  vim.api.nvim_command('e ' .. filepath)
end

local function handle_buf_enter()
  if not vim.w.original_dir then
    vim.w.original_dir = vim.fn.getcwd()
  end

  vim.api.nvim_command('lcd ' .. vim.fn.expand('$NOTES_DIR'))
end

local function handle_buf_leave()
  vim.api.nvim_command('lcd ' .. vim.w.original_dir)
  vim.w.original_dir = nil
end

local M = {}

M.new_note = new_note
M.handle_buf_enter = handle_buf_enter
M.handle_buf_leave = handle_buf_leave

usr_util.create_augroups({
  UsrNotes = {
    {'BufEnter,BufRead', notes_glob, [[lua require'usr.plugin.notes'.handle_buf_enter()]]},
    {'BufLeave', notes_glob, [[lua require'usr.plugin.notes'.handle_buf_leave()]]},
  }
})

vim.api.nvim_command([[command NewNote lua require'usr.plugin.notes'.new_note()]])
-- this is called before <leader> is set, so just hardcode it to <Space> for now
vim.fn.nvim_set_keymap('n', '<Space>nn', [[<cmd>NewNote<CR>]], {noremap = true, silent = true})

return M
