local usr_util = require'usr.util'

local hl_diagnostics =
  'highlight clear DiagnosticError'
  .. ' | ' .. 'highlight clear DiagnosticWarn'
  .. ' | ' .. 'highlight clear DiagnosticInformation'
  .. ' | ' .. 'highlight clear DiagnosticHint'
  .. ' | ' .. 'highlight link DiagnosticError DiffDelete'
  .. ' | ' .. 'highlight link DiagnosticWarn DiffText'
  .. ' | ' .. 'highlight link DiagnosticInformation DiffAdd'
  .. ' | ' .. 'highlight link DiagnosticHint DiffChange'


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

  local statusline_fg = usr_util.get_hi_attr('PmenuThumb', 'bg#', 'gui')
  vim.api.nvim_command('highlight StatusLine cterm=reverse gui=reverse guifg=' ..statusline_fg)
  usr_util.extend_hi_gui('StatusLine', 'StatusLineNC', { reverse = true })


  vim.api.nvim_command(hl_diagnostics)

  usr_util.extend_hi_gui('DiagnosticError', 'stlLspError', {
    reverse = false,
    inverse = false,
    bold = true,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('DiagnosticWarn', 'stlLspWarning', {
    reverse = false,
    inverse = false,
    bold = true,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('DiagnosticInformation', 'stlLspInformation', {
    reverse = false,
    inverse = false,
    bold = true,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('DiagnosticHint', 'stlLspHint', {
    reverse = false,
    inverse = false,
    bold = true,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  vim.api.nvim_command('highlight link DiagnosticFloatingError stlLspError')
  vim.api.nvim_command('highlight link DiagnosticFloatingWarn stlLspWarning')
  vim.api.nvim_command('highlight link DiagnosticFloatingInformation stlLspInformation')
  vim.api.nvim_command('highlight link DiagnosticFloatingHint stlLspHint')

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
