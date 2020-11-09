local usr_util = require'usr.util'

local hl_diagnostics =
              'highlight link LspDiagnosticsError DiffDelete'
  .. ' | ' .. 'highlight link LspDiagnosticsWarning DiffText'
  .. ' | ' .. 'highlight link LspDiagnosticsInformation DiffChange'
  .. ' | ' .. 'highlight link LspDiagnosticsHint DiffAdd'


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


  vim.api.nvim_command(hl_diagnostics)

  usr_util.extend_hi_gui('LspDiagnosticsError', 'stlLspError', {
    reverse = false,
    inverse = false,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('LspDiagnosticsWarning', 'stlLspWarning', {
    reverse = false,
    inverse = false,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('LspDiagnosticsInformation', 'stlLspInfo', {
    reverse = false,
    inverse = false,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  usr_util.extend_hi_gui('LspDiagnosticsHint', 'stlLspHint', {
    reverse = false,
    inverse = false,
    bg = usr_util.get_hi_attr('Pmenu', 'bg', 'gui'),
  })

  vim.api.nvim_command('highlight link LspDiagnosticsFloatingError stlLspError')
  vim.api.nvim_command('highlight link LspDiagnosticsFloatingWarning stlLspWarning')
  vim.api.nvim_command('highlight link LspDiagnosticsFloatingInfo stlLspInfo')
  vim.api.nvim_command('highlight link LspDiagnosticsFloatingHint stlLspHint')
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
