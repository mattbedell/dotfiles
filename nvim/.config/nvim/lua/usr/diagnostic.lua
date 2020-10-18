local util = require 'vim.lsp.util'
local vim = vim
local api = vim.api

local M = {}

--@see https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_publishDiagnostics
--M['textDocument/publishDiagnostics'] = function(_, _, result)
--  if not result then return end
--  local uri = result.uri
--  local bufnr = vim.uri_to_bufnr(uri)
--  if not bufnr then
--    err_message("LSP.publishDiagnostics: Couldn't find buffer for ", uri)
--    return
--  end

--  -- Unloaded buffers should not handle diagnostics.
--  --    When the buffer is loaded, we'll call on_attach, which sends textDocument/didOpen.
--  --    This should trigger another publish of the diagnostics.
--  --
--  -- In particular, this stops a ton of spam when first starting a server for current
--  -- unloaded buffers.
--  if not api.nvim_buf_is_loaded(bufnr) then
--    return
--  end

--  util.buf_clear_diagnostics(bufnr)

--  -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#diagnostic
--  -- The diagnostic's severity. Can be omitted. If omitted it is up to the
--  -- client to interpret diagnostics as error, warning, info or hint.
--  -- TODO: Replace this with server-specific heuristics to infer severity.
--  for _, diagnostic in ipairs(result.diagnostics) do
--    if diagnostic.severity == nil then
--      diagnostic.severity = protocol.DiagnosticSeverity.Error
--    end
--  end

--  util.buf_diagnostics_save_positions(bufnr, result.diagnostics)
--  util.buf_diagnostics_underline(bufnr, result.diagnostics)
--  util.buf_diagnostics_virtual_text(bufnr, result.diagnostics)
--  util.buf_diagnostics_signs(bufnr, result.diagnostics)
--  api.nvim_command("doautocmd User LspDiagnosticsChanged")
--end

local display_diagnostics = function(bufnr, diagnostics)
  util.buf_diagnostics_underline(bufnr, diagnostics)
  -- util.buf_diagnostics_virtual_text(bufnr, result.diagnostics)
  util.buf_diagnostics_signs(bufnr, diagnostics)
  api.nvim_command("doautocmd User LspDiagnosticsChanged")
end

local publish_diagnostics_cb = function(_, _, result)
  if not result then
    return
  end
  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)
  if not bufnr then
    err_message("LSP.publishDiagnostics: Couldn't find buffer for ", uri)
    return
  end
  if not api.nvim_buf_is_loaded(bufnr) then
    return
  end

  util.buf_clear_diagnostics(bufnr)

  for _, diagnostic in ipairs(result.diagnostics) do
    if diagnostic.severity == nil then
      diagnostic.severity = protocol.DiagnosticSeverity.Error
    end
  end

  util.buf_diagnostics_save_positions(bufnr, result.diagnostics)

  if api.nvim_get_mode()['mode'] == "i" or api.nvim_get_mode()['mode'] == "ic" then
    return
  end

  display_diagnostics(bufnr, result.diagnostics)
end

M.on_insert_leave = function()
  local bufnr = api.nvim_win_get_buf(0)
  local diagnostics = vim.lsp.util.diagnostics_by_buf[bufnr]
  display_diagnostics(bufnr, diagnostics)
end

M.on_attach = function(_, _)
  vim.lsp.callbacks['textDocument/publishDiagnostics'] = publish_diagnostics_cb

  api.nvim_command [[augroup DiagnosticInsertDelay]]
  api.nvim_command("autocmd! * <buffer>")
  api.nvim_command [[autocmd InsertLeave <buffer> lua require'usr.diagnostic'.on_insert_leave()]]
  api.nvim_command [[augroup end]]
end

return M
