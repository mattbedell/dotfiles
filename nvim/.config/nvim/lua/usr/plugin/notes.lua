local usr_util = require'usr.util'

local notes_glob = vim.fn.expand('$NOTES_DIR') .. '/*.md'

local function get_relative_filepath(from_filepath)
  local rel_path_cmd = string.format('realpath --relative-to=%s %s', vim.fn.shellescape(vim.fn.expand('%:h')), vim.fn.shellescape(from_filepath))
  return vim.fn.systemlist(rel_path_cmd)[1]
end

local function insert_md_link(link_text, link_path)
  local linenr = vim.fn.line('.')
  local colnr = vim.fn.col('.')

  if not link_text then
    -- use the filename if no link text is provided
    link_text = vim.fn.fnamemodify(link_path, ':t:r')
  end

  local link_to_insert = string.format(' [%s](%s)', link_text, link_path)
  local line_contents = vim.fn.getline('.')
  local line_modified = vim.fn.strpart(line_contents, 0, colnr) .. link_to_insert .. vim.fn.strpart(line_contents, colnr)
  vim.fn.setline(linenr, line_modified)
end

local function new_note(with_link)
  local filename = vim.fn.strftime('%Y%m%d%H%M') .. '.md'
  local notes_dir = vim.fn.expand('$NOTES_DIR')
  local filepath =  notes_dir .. '/' .. filename

  -- create a new note and link to it from the current note
  if with_link then
    local is_notes_dir = vim.fn.fnamemodify(notes_dir, ':~') == vim.fn.fnamemodify(vim.fn.expand('%'), ':~:h')

    if is_notes_dir then
      local relative_filepath = get_relative_filepath(filepath)
      insert_md_link(nil, relative_filepath)
    end
  end

  vim.api.nvim_command('e ' .. filepath)
end

local function handle_buf_enter()
  if not vim.w.original_dir then
    vim.w.original_dir = vim.fn.getcwd()
  end

  vim.api.nvim_command('lcd ' .. vim.fn.expand('$NOTES_DIR'))
end

local function handle_buf_leave()
  if vim.w.original_dir ~= nil then
    vim.api.nvim_command('lcd ' .. vim.w.original_dir)
    vim.w.original_dir = nil
  end
end

local function fzf_rg_note_link_handle(rg_match)
  local filepath = vim.fn.matchstr(rg_match, [[^\zs.\{-}\ze:]])
  local relative_filepath = get_relative_filepath(filepath)
  insert_md_link(nil, relative_filepath)
end

local function fzf_rg_note_link(fullscreen, ...)
  local args = {...}
  local search_cmd = 'rg --column --line-number --no-heading --color=always --smart-case --hidden -g "!.git"'
  if #args > 0 then
    for _,v in ipairs(args) do
      search_cmd = search_cmd .. ' ' .. v
    end
  else
    search_cmd = search_cmd .. ' ""'
  end

  local notes_dir = vim.fn.expand('$NOTES_DIR')
  local is_notes_dir = vim.fn.fnamemodify(notes_dir, ':~') == vim.fn.fnamemodify(vim.fn.expand('%'), ':~:h')
  if is_notes_dir then
    local with_preview = vim.fn['fzf#vim#with_preview']({ sink = 'NLink' })
    vim.fn['fzf#vim#grep'](search_cmd, 1, with_preview, fullscreen)
  end

end

local M = {}

M.new_note = new_note
M.handle_buf_enter = handle_buf_enter
M.handle_buf_leave = handle_buf_leave
M.fzf_rg_note_link = fzf_rg_note_link
M.fzf_rg_note_link_handle = fzf_rg_note_link_handle

usr_util.create_augroups({
  UsrNotes = {
    {'BufEnter', notes_glob, [[setlocal makeprg=cd\ $NOTES_DIR/..\ &&\ ctags\ -R\ $NOTES_DIR]]},
    {'BufEnter,BufRead', notes_glob, [[lua require'usr.plugin.notes'.handle_buf_enter()]]},
    {'BufLeave', notes_glob, [[lua require'usr.plugin.notes'.handle_buf_leave()]]},
  }
})

vim.api.nvim_command([[command NoteNew lua require'usr.plugin.notes'.new_note()]])
vim.api.nvim_command([[command! -bang -nargs=* NoteLink lua require'usr.plugin.notes'.fzf_rg_note_link(<bang>0, <f-args>)]])

-- this command is executed by FZF when the user makes a choice from the NRg command above
vim.api.nvim_command([[command! -bang -nargs=* NLink lua require'usr.plugin.notes'.fzf_rg_note_link_handle(<f-args>)]])

-- this is called before <leader> is set, so just hardcode it to <Space> for now
vim.fn.nvim_set_keymap('n', '<Space>nn', [[<cmd>NoteNew<CR>]], {noremap = true, silent = true})
vim.fn.nvim_set_keymap('n', '<Space>nl', [[:NoteLink ]], {noremap = true})
vim.fn.nvim_set_keymap('n', '<Space>na', [[<cmd>lua require'usr.plugin.notes'.new_note(true)<CR>]], {noremap = true})
vim.fn.nvim_set_keymap('n', '<Space>ng', [[<cmd>tabnew|setlocal bufhidden=wipe|setlocal nobuflisted|setlocal nomodifiable|tcd $NOTES_DIR<CR>]], {noremap = true})

return M
