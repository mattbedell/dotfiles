local vim = vim
local fn = vim.fn

local M = {}

local function join(list, delim)
  -- lua lists conventionally start at 1 which is ...something
  -- getting a list length this way just gets the largest numerical index, which is also ...something
  local len = #list
  if len == 0 then return "" end
  local str = list[1]
  for i = 2, len do
    str = str .. delim .. list[i]
  end
  return str
end

local function get_hi_attr(hi_name, attr, mode)
  local id = fn.synIDtrans(fn.hlID(hi_name))
  return fn.synIDattr(id, attr, mode)
end

-- create a new a gui highlight group that extends an existing one
local function extend_hi_gui(super_hl, highlight_name, opts)
  local term_gui_attrs = {"bold", "underline", "undercurl", "strikethrough", "reverse", "inverse", "italic", "standout"}
  local hi_tg_attrs = {}

  local super_id = fn.synIDtrans(fn.hlID(super_hl))
  local bg = opts.bg ~= nil and opts.bg or get_hi_attr(super_id, 'bg#', 'gui') or nil
  local fg = opts.fg ~= nil and opts.fg or get_hi_attr(super_id, 'fg#', 'gui') or nil

  for _, attr in ipairs(term_gui_attrs) do
    if opts[attr] then
      table.insert(hi_tg_attrs, attr)
    else
      local has_attr = vim.fn.synIDattr(super_id, attr)
      if has_attr == '1' then
        table.insert(hi_tg_attrs, attr)
      end
    end
  end

  hi_tg_attrs = join(hi_tg_attrs, ',')
  local hi = 'highlight '
  .. highlight_name
  .. ' gui=' .. hi_tg_attrs
  .. ' cterm=' .. hi_tg_attrs
  .. ' guifg=' .. fg
  .. ' guibg=' .. bg
  vim.api.nvim_command(hi)
end

-- https://github.com/jamestthompson3/vimConfig/blob/master/lua/nvim_utils.lua
-- usage:
-- local autocmds = {
--   au_group_name = {
--     {"BufEnter",        "*",      [[lua require'completion'.on_attach()]]};
--     {"FocusGained,CursorMoved,CursorMovedI", "*", "checktime"};
--   }
-- }

local function create_augroups(definitions)
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

M.create_augroups = create_augroups
M.extend_hi_gui = extend_hi_gui
M.get_hi_attr = get_hi_attr

return M
