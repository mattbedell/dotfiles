local usr_util = require'usr.util'

local function update_highlights()
  usr_util.extend_hi_gui('StatusLine', 'stlWarn', {
    reverse = true,
    bold = true,
    bg = usr_util.get_hi_attr('Question', 'fg', 'gui'),
    fg = usr_util.get_hi_attr('PmenuThumb', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('StatusLineNC', 'stlWarnNC', {
    reverse = true,
    bold = true,
  })

  usr_util.extend_hi_gui('StatusLine', 'stlGit', {
    reverse = true,
    bg = usr_util.get_hi_attr('Identifier', 'fg', 'gui'),
    fg = usr_util.get_hi_attr('PmenuThumb', 'bg', 'gui'),
  })

  local statusline_bg = usr_util.get_hi_attr('PmenuThumb', 'bg#', 'gui')
  vim.api.nvim_command('highlight StatusLine guibg=' ..statusline_bg)
  usr_util.extend_hi_gui('StatusLine', 'StatusLineNC', {})

  usr_util.extend_hi_gui('DiagnosticError', 'stlLspError', {
    reverse = false,
    inverse = false,
    bold = true,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('DiagnosticError', 'DiagnosticSignError', {
    reverse = false,
    inverse = true,
    bold = false,
  })

  usr_util.extend_hi_gui('DiagnosticWarn', 'stlLspWarning', {
    reverse = false,
    inverse = false,
    bold = true,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('DiagnosticWarn', 'DiagnosticSignWarn', {
    reverse = false,
    inverse = true,
    bold = false,
  })

  usr_util.extend_hi_gui('DiagnosticInfo', 'stlLspInformation', {
    reverse = false,
    inverse = false,
    bold = true,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('DiagnosticInfo', 'DiagnosticSignInfo', {
    reverse = false,
    inverse = true,
    bold = false,
  })

  usr_util.extend_hi_gui('DiagnosticHint', 'stlLspHint', {
    reverse = false,
    inverse = false,
    bold = true,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('DiagnosticHint', 'DiagnosticSignHint', {
    reverse = false,
    inverse = true,
    bold = false,
  })

  vim.api.nvim_command('highlight clear SpellBad | highlight link SpellBad ErrorMsg')
end

local M = {}

M.update_highlights = update_highlights

usr_util.create_augroups({
  UsrHighlights = {
    {'ColorScheme', '*', [[lua require'usr.highlights'.update_highlights()]]},
    {'OptionSet', 'background', [[lua require'usr.highlights'.update_highlights()]]},
  }
})

return M
