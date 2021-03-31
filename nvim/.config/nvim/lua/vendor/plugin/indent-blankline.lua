local usr_util = require'usr.util'


local function update_indent_hi()
  local ident_fg = usr_util.get_hi_attr('Normal', 'bg#', 'gui')
  if string.len(ident_fg) == 0 then
    ident_fg = 'None'
  end

  if vim.g.colors_name == 'gruvbox' and vim.api.nvim_get_option('background') == 'light' then
    ident_fg = '#ebe6c7'
  end

  vim.api.nvim_command('highlight IndentBlanklineChar guifg=' ..ident_fg)
end

vim.api.nvim_set_var('indent_blankline_char', '▏')
vim.api.nvim_set_var('indent_blankline_use_treesitter', true)
vim.api.nvim_set_var('indent_blankline_show_current_context', true)
vim.api.nvim_set_var('indent_blankline_context_patterns', { 'class', 'function', 'method', 'object_pattern', 'statement_block' })
vim.api.nvim_set_var('indent_blankline_show_trailing_blankline_indent', false)
vim.api.nvim_set_var('indent_blankline_context_highlight_list', { 'Boolean' })
vim.api.nvim_set_var('indent_blankline_buftype_exclude', { 'help', 'terminal' })
vim.api.nvim_set_var('indent_blankline_filetype_exclude', { 'markdown' })

local M = {}

M.update_indent_hi = update_indent_hi

usr_util.create_augroups({
  IndentHighlights = {
    {'ColorScheme', '*', [[lua require'vendor.plugin.indent-blankline'.update_indent_hi()]]},
    {'OptionSet', 'background', [[lua require'vendor.plugin.indent-blankline'.update_indent_hi()]]},
  }
})


return M
