local usr_util = require'usr.util'

usr_util.create_augroups({
  WinAutoResize = {
    {'VimResized', '*', 'wincmd ='},
  }
})

local HLSearchGroup = vim.api.nvim_create_augroup('auto-hlsearch', { clear = true })

vim.api.nvim_create_autocmd('CursorMoved', {
  group = HLSearchGroup,
  callback = function ()
    if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
      vim.schedule(function () vim.cmd.nohlsearch() end)
    end
  end
})

vim.api.nvim_create_autocmd("WinNew", {
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= "" then
      vim.api.nvim_win_call(0, function()
        vim.cmd("set winhighlight=NormalNC:Normal")
      end)
    end
  end,
})

local AutoIndentUtil = vim.api.nvim_create_augroup('auto-indent-util', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  group = AutoIndentUtil,
  pattern = { '*.ts' },
  callback = function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false)
    local space_count = 0
    for _, line in ipairs(lines) do
      if space_count > 10 then
        vim.bo.expandtab = true
        break
      end

      if line:find("^\t") then
        vim.bo.expandtab = false
        break
      end

      if line:find("^ ") then
        space_count = space_count + 1
      end
    end
  end
})

local function set_lsp_reference_highlights()
  for _, group in ipairs({ 'LspReferenceText', 'LspReferenceRead', 'LspReferenceWrite' }) do
    vim.api.nvim_set_hl(0, group, { link = 'Visual' })
  end
end

set_lsp_reference_highlights()

local LspHighlightReferences = vim.api.nvim_create_augroup('lsp-highlight-refs', { clear = true })

vim.api.nvim_create_autocmd('ColorScheme', {
  group = LspHighlightReferences,
  callback = set_lsp_reference_highlights,
})

vim.api.nvim_create_autocmd("CursorHold", {
  group = LspHighlightReferences,
  callback = function(event)
    local method = vim.lsp.protocol.Methods.textDocument_documentHighlight
    if #vim.lsp.get_clients({ bufnr = event.buf, method = method }) > 0 then
      vim.lsp.buf.document_highlight()
    end
  end,
})

vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
  group = LspHighlightReferences,
  callback = function()
    vim.lsp.buf.clear_references()
  end,
})
