-- https://github.com/jamestthompson3/vimConfig/blob/master/lua/nvim_utils.lua
-- usage:
-- local autocmds = {
--   au_group_name = {
--     {"BufEnter",        "*",      [[lua require'completion'.on_attach()]]};
--     {"FocusGained,CursorMoved,CursorMovedI", "*", "checktime"};
--   }
-- }

function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end
